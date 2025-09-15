resource "aws_route53_record" "www" {
  # 위에서 찾은 Hosted Zone ID를 사용
#   zone_id = data.aws_route53_zone.selected.zone_id
  zone_id = var.aws_route53_zone
  # 생성할 레코드의 이름
  name    = "www1.itskillboost.com"
  # 레코드 타입: A 레코드 (Alias는 A 또는 AAAA 레코드에서 사용)
  type    = "A"

  # Alias(별칭) 설정
  alias {
    # 대상의 DNS 이름: CloudFront 리소스의 'domain_name' 속성을 그대로 참조합니다.
    name                   = aws_cloudfront_distribution.alb_distribution.domain_name
    # 대상의 Hosted Zone ID: CloudFront 리소스의 'hosted_zone_id' 속성을 참조합니다.
    zone_id                = aws_cloudfront_distribution.alb_distribution.hosted_zone_id
    # 대상 상태 평가는 CloudFront Alias에서는 사용하지 않음
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "alb_distribution" {
  # 활성화 여부
  enabled             = true
  # CloudFront에 연결할 도메인 이름 (CNAME)
  aliases             = ["www1.itskillboost.com"]
  # 기본 가격 정책 (PriceClass_All, PriceClass_200, PriceClass_100)
  # PriceClass_200: 미국, 유럽, 아시아 지역 포함 (합리적인 선택)
  price_class         = "PriceClass_200"

  # 1. 원본(Origin) 설정: 어디서 콘텐츠를 가져올 것인가?
  origin {
    # 원본의 도메인 주소 (제공해주신 ALB의 DNS 주소)
    domain_name = var.itskillboost-alb
    # 원본을 식별하기 위한 고유한 이름
    origin_id   = "alb-origin-itskillboost"

    # S3가 아닌 커스텀 원본(ALB, EC2 등)을 위한 설정 블록
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      # CloudFront -> ALB 통신 프로토콜. ALB가 80 포트를 수신 대기하므로 'http-only'로 설정합니다.
      # 사용자와 CloudFront 간의 통신은 HTTPS로 안전하게 유지됩니다.
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  # 2. 기본 캐시 동작(Default Cache Behavior) 설정: 콘텐츠를 어떻게 처리하고 전달할 것인가?
  default_cache_behavior {
    # 위에서 정의한 원본(origin_id)과 연결
    target_origin_id = "alb-origin-itskillboost"

    # 사용자의 프로토콜 정책: 요청하신 대로 HTTP를 HTTPS로 자동 전환합니다.
    viewer_protocol_policy = "redirect-to-https"

    # 허용할 HTTP 메서드
    allowed_methods    = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    # 캐싱할 HTTP 메서드 (일반적으로 GET, HEAD만 캐싱)
    cached_methods     = ["GET", "HEAD"]

    # 캐시 키 설정: 무엇을 기준으로 콘텐츠를 캐싱할지 결정 (매우 중요!)
    # 동적 콘텐츠 처리를 위해 모든 쿠키와 쿼리 문자열을 원본(ALB)으로 전달합니다.
    # 이렇게 하면 개인화된 콘텐츠는 잘 동작하지만, 캐시 효율은 낮아질 수 있습니다.
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  # 3. 뷰어 인증서(Viewer Certificate) 설정: 도메인에 SSL을 어떻게 적용할 것인가?
  viewer_certificate {
    # 제공해주신 ACM 인증서 ARN
    acm_certificate_arn      = var.acm_arn
    # 최신 브라우저 표준인 SNI(Server Name Indication) 방식만 지원
    ssl_support_method       = "sni-only"
  }

  # 4. 기타 설정
  restrictions {
    geo_restriction {
      restriction_type = "none" # 특정 국가 차단/허용 안 함
    }
  }

  # 리소스를 관리하기 위한 태그
  tags = {
    Name        = "cloudfront-itskillboost-com"
    Environment = "production"
  }
}