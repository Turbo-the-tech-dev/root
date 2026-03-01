#!/usr/bin/env python3
# =============================================================================
# bug-bounty.py — Imperial Security Scanner (Sector 09)
# "El Perro Guardián" — The Guardian Dog
# =============================================================================
#
# Automated vulnerability scanner for the Turbo Empire
# Runs in the shadows, finds weaknesses before hackers do
#
# USAGE: python3 bug-bounty.py [--target URL] [--full-scan] [--json]
# =============================================================================

import sys
import json
import time
import requests
import argparse
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
from enum import Enum

# =============================================================================
# Configuration (Sector 09 Security Parameters)
# =============================================================================

class Severity(Enum):
    CRITICAL = "CRITICAL"
    HIGH = "HIGH"
    MEDIUM = "MEDIUM"
    LOW = "LOW"
    INFO = "INFO"

@dataclass
class Vulnerability:
    id: str
    severity: str
    title: str
    description: str
    endpoint: str
    remediation: str
    detected_at: str

# Default configuration
DEFAULT_CONFIG = {
    "target_url": "https://api.turbo-empire.tech/v1",
    "firebase_url": "https://turbo-empire.firebaseio.com",
    "aws_s3_buckets": ["imperio-turbo-prod", "imperio-turbo-staging"],
    "timeout": 10,
    "user_agent": "Imperial-Security-Scanner/2.0",
    "rate_limit": 1.0,  # seconds between requests
}

# =============================================================================
# Security Scanner Class
# =============================================================================

class ImperialSecurityScanner:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": config["user_agent"],
            "X-Imperial-Scanner": "true"
        })
        self.vulnerabilities: List[Vulnerability] = []
        self.scan_start = datetime.now()
        
    def log(self, message: str, level: str = "INFO"):
        """Formatted logging"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        icons = {
            "INFO": "🔍",
            "SUCCESS": "✓",
            "WARN": "⚠️",
            "ERROR": "❌",
            "CRITICAL": "🚨"
        }
        print(f"[{timestamp}] [{icons.get(level, '•')}] {message}")
        
    def check_sql_injection(self, endpoint: str) -> Optional[Vulnerability]:
        """Test for SQL injection vulnerabilities"""
        self.log(f"Testing SQL injection on {endpoint}")
        
        # Common SQL injection payloads
        payloads = [
            {"voltage": "120; DROP TABLE users--", "amperage": 20},
            {"voltage": "120' OR '1'='1", "amperage": 20},
            {"voltage": "120'; DELETE FROM audit_logs--", "amperage": 20},
        ]
        
        for payload in payloads:
            try:
                response = self.session.post(
                    f"{self.config['target_url']}/{endpoint}",
                    json=payload,
                    timeout=self.config["timeout"]
                )
                
                # Check for SQL error messages
                sql_errors = ["SQL syntax", "mysql_fetch", "ORA-", "PostgreSQL", "SQLite"]
                for error in sql_errors:
                    if error in response.text:
                        return Vulnerability(
                            id="SQLi-001",
                            severity=Severity.CRITICAL.value,
                            title="SQL Injection Detected",
                            description=f"Endpoint {endpoint} is vulnerable to SQL injection",
                            endpoint=endpoint,
                            remediation="Use parameterized queries. Implement input validation.",
                            detected_at=datetime.now().isoformat()
                        )
                
                # Check if server properly rejected malicious input
                if response.status_code not in [400, 403, 422]:
                    self.log(f"  ⚠️ Suspicious: Server accepted suspicious input", "WARN")
                    
            except requests.exceptions.RequestException as e:
                self.log(f"  Error testing {endpoint}: {str(e)}", "ERROR")
            
            time.sleep(self.config["rate_limit"])
        
        self.log(f"  ✓ No SQL injection detected", "SUCCESS")
        return None
        
    def check_jwt_security(self) -> Optional[Vulnerability]:
        """Audit JWT token security"""
        self.log("Auditing JWT token security...")
        
        # Test 1: Check for 'none' algorithm vulnerability
        try:
            # Simulate JWT with 'none' algorithm
            headers = {"Authorization": "Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6ImFkbWluIiwiaWF0IjoxNTE2MjM5MDIyfQ."}
            response = self.session.get(
                f"{self.config['target_url']}/auth/verify",
                headers=headers,
                timeout=self.config["timeout"]
            )
            
            if response.status_code == 200:
                return Vulnerability(
                    id="JWT-001",
                    severity=Severity.CRITICAL.value,
                    title="JWT 'none' Algorithm Vulnerability",
                    description="Server accepts JWT with 'none' algorithm",
                    endpoint="/auth/verify",
                    remediation="Reject tokens with 'none' algorithm. Validate algorithm explicitly.",
                    detected_at=datetime.now().isoformat()
                )
        except Exception as e:
            self.log(f"  JWT none test error: {str(e)}", "ERROR")
        
        # Test 2: Check token expiration validation
        try:
            # Expired token (from 2020)
            expired_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiZXhwIjoxNTc3ODM2ODAwfQ.expired"
            headers = {"Authorization": f"Bearer {expired_token}"}
            response = self.session.get(
                f"{self.config['target_url']}/auth/verify",
                headers=headers,
                timeout=self.config["timeout"]
            )
            
            if response.status_code == 200:
                return Vulnerability(
                    id="JWT-002",
                    severity=Severity.HIGH.value,
                    title="JWT Expiration Not Validated",
                    description="Server accepts expired JWT tokens",
                    endpoint="/auth/verify",
                    remediation="Validate token expiration on every request.",
                    detected_at=datetime.now().isoformat()
                )
        except Exception as e:
            self.log(f"  JWT expiration test error: {str(e)}", "ERROR")
        
        self.log("  ✓ JWT security checks passed", "SUCCESS")
        return None
        
    def check_s3_bucket_permissions(self, bucket: str) -> Optional[Vulnerability]:
        """Check S3 bucket for public read permissions"""
        self.log(f"Checking S3 bucket permissions: {bucket}")
        
        try:
            # Try to list bucket contents (should fail if private)
            response = self.session.get(
                f"https://{bucket}.s3.amazonaws.com/",
                timeout=self.config["timeout"]
            )
            
            # If we get a listing, bucket is publicly readable
            if response.status_code == 200 and "ListBucketResult" in response.text:
                return Vulnerability(
                    id="S3-001",
                    severity=Severity.HIGH.value,
                    title="S3 Bucket Public Read Access",
                    description=f"Bucket {bucket} allows public listing",
                    endpoint=f"s3://{bucket}",
                    remediation="Remove public read access. Use bucket policies for controlled access.",
                    detected_at=datetime.now().isoformat()
                )
                
            # Check for AccessDenied (good - means bucket is private)
            if response.status_code == 403:
                self.log(f"  ✓ Bucket {bucket} is properly private", "SUCCESS")
                return None
                
        except Exception as e:
            self.log(f"  S3 check error: {str(e)}", "ERROR")
        
        return None
        
    def check_cors_policy(self, endpoint: str) -> Optional[Vulnerability]:
        """Test CORS policy configuration"""
        self.log(f"Testing CORS policy on {endpoint}")
        
        try:
            # Test with malicious origin
            headers = {
                "Origin": "https://evil-attacker-site.com"
            }
            response = self.session.options(
                f"{self.config['target_url']}/{endpoint}",
                headers=headers,
                timeout=self.config["timeout"]
            )
            
            # Check if server reflects malicious origin
            acao_header = response.headers.get("Access-Control-Allow-Origin", "")
            
            if acao_header == "*" or acao_header == "https://evil-attacker-site.com":
                return Vulnerability(
                    id="CORS-001",
                    severity=Severity.MEDIUM.value,
                    title="Overly Permissive CORS Policy",
                    description=f"Endpoint {endpoint} allows arbitrary origins",
                    endpoint=endpoint,
                    remediation="Whitelist specific origins. Do not use wildcard (*) for sensitive APIs.",
                    detected_at=datetime.now().isoformat()
                )
                
            self.log(f"  ✓ CORS policy properly configured", "SUCCESS")
            
        except Exception as e:
            self.log(f"  CORS test error: {str(e)}", "ERROR")
        
        return None
        
    def check_security_headers(self, endpoint: str) -> List[Vulnerability]:
        """Check for missing security headers"""
        self.log(f"Checking security headers on {endpoint}")
        
        vulns = []
        required_headers = {
            "Strict-Transport-Security": "HSTS header missing",
            "X-Content-Type-Options": "X-Content-Type-Options header missing",
            "X-Frame-Options": "X-Frame-Options header missing",
            "Content-Security-Policy": "CSP header missing",
            "X-XSS-Protection": "X-XSS-Protection header missing",
        }
        
        try:
            response = self.session.get(
                f"{self.config['target_url']}/{endpoint}",
                timeout=self.config["timeout"]
            )
            
            for header, description in required_headers.items():
                if header not in response.headers:
                    vulns.append(Vulnerability(
                        id=f"HEADERS-{len(vulns)+1:03d}",
                        severity=Severity.LOW.value,
                        title="Missing Security Header",
                        description=description,
                        endpoint=endpoint,
                        remediation=f"Add {header} header to all responses.",
                        detected_at=datetime.now().isoformat()
                    ))
                    
            if not vulns:
                self.log(f"  ✓ All security headers present", "SUCCESS")
            else:
                self.log(f"  ⚠️ {len(vulns)} security headers missing", "WARN")
                
        except Exception as e:
            self.log(f"  Headers check error: {str(e)}", "ERROR")
        
        return vulns
        
    def run_full_scan(self) -> Dict[str, Any]:
        """Execute comprehensive security scan"""
        self.log("🚀 Starting Imperial Security Scan...", "INFO")
        print("=" * 60)
        
        endpoints_to_scan = [
            "nec-audit",
            "auth/verify",
            "users",
            "firebase/sync",
        ]
        
        # SQL Injection Tests
        print("\n[📍] Phase 1: SQL Injection Tests")
        for endpoint in endpoints_to_scan:
            vuln = self.check_sql_injection(endpoint)
            if vuln:
                self.vulnerabilities.append(vuln)
        
        # JWT Security
        print("\n[📍] Phase 2: JWT Security Audit")
        vuln = self.check_jwt_security()
        if vuln:
            self.vulnerabilities.append(vuln)
        
        # S3 Bucket Permissions
        print("\n[📍] Phase 3: S3 Bucket Permissions")
        for bucket in self.config["aws_s3_buckets"]:
            vuln = self.check_s3_bucket_permissions(bucket)
            if vuln:
                self.vulnerabilities.append(vuln)
        
        # CORS Policy
        print("\n[📍] Phase 4: CORS Policy Tests")
        for endpoint in endpoints_to_scan[:2]:
            vuln = self.check_cors_policy(endpoint)
            if vuln:
                self.vulnerabilities.append(vuln)
        
        # Security Headers
        print("\n[📍] Phase 5: Security Headers Check")
        for endpoint in endpoints_to_scan[:3]:
            vulns = self.check_security_headers(endpoint)
            self.vulnerabilities.extend(vulns)
        
        # Generate Report
        scan_duration = (datetime.now() - self.scan_start).total_seconds()
        
        report = {
            "scan_id": f"IMPERIAL-{datetime.now().strftime('%Y%m%d-%H%M%S')}",
            "scan_start": self.scan_start.isoformat(),
            "scan_end": datetime.now().isoformat(),
            "duration_seconds": scan_duration,
            "target": self.config["target_url"],
            "vulnerabilities_found": len(self.vulnerabilities),
            "severity_breakdown": {
                "CRITICAL": len([v for v in self.vulnerabilities if v.severity == "CRITICAL"]),
                "HIGH": len([v for v in self.vulnerabilities if v.severity == "HIGH"]),
                "MEDIUM": len([v for v in self.vulnerabilities if v.severity == "MEDIUM"]),
                "LOW": len([v for v in self.vulnerabilities if v.severity == "LOW"]),
                "INFO": len([v for v in self.vulnerabilities if v.severity == "INFO"]),
            },
            "vulnerabilities": [asdict(v) for v in self.vulnerabilities],
            "status": "CRITICAL" if any(v.severity == "CRITICAL" for v in self.vulnerabilities) else "PASS"
        }
        
        return report

# =============================================================================
# Main Execution
# =============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="🐕 Imperial Security Scanner — El Perro Guardián"
    )
    parser.add_argument(
        "--target", "-t",
        default=DEFAULT_CONFIG["target_url"],
        help="Target API URL"
    )
    parser.add_argument(
        "--firebase", "-f",
        default=DEFAULT_CONFIG["firebase_url"],
        help="Firebase URL"
    )
    parser.add_argument(
        "--full-scan",
        action="store_true",
        help="Run comprehensive scan (all tests)"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output results as JSON"
    )
    parser.add_argument(
        "--rate-limit",
        type=float,
        default=1.0,
        help="Rate limit in seconds between requests"
    )
    
    args = parser.parse_args()
    
    # Build configuration
    config = DEFAULT_CONFIG.copy()
    config["target_url"] = args.target
    config["firebase_url"] = args.firebase
    config["rate_limit"] = args.rate_limit
    
    # Initialize scanner
    scanner = ImperialSecurityScanner(config)
    
    # Run scan
    if args.full_scan:
        report = scanner.run_full_scan()
    else:
        # Quick scan (just critical tests)
        scanner.log("Running quick security scan (critical tests only)...")
        vuln = scanner.check_sql_injection("nec-audit")
        if vuln:
            scanner.vulnerabilities.append(vuln)
        vuln = scanner.check_jwt_security()
        if vuln:
            scanner.vulnerabilities.append(vuln)
        
        report = {
            "scan_id": f"IMPERIAL-QUICK-{datetime.now().strftime('%Y%m%d-%H%M%S')}",
            "vulnerabilities_found": len(scanner.vulnerabilities),
            "status": "CRITICAL" if scanner.vulnerabilities else "PASS",
            "vulnerabilities": [asdict(v) for v in scanner.vulnerabilities]
        }
    
    # Output results
    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print("\n" + "=" * 60)
        print("[📊] SCAN RESULTS")
        print("=" * 60)
        print(f"Scan ID: {report['scan_id']}")
        print(f"Duration: {report.get('duration_seconds', 'N/A')} seconds")
        print(f"Vulnerabilities Found: {report['vulnerabilities_found']}")
        print(f"Status: {report['status']}")
        
        if report["vulnerabilities"]:
            print("\n[🚨] VULNERABILITIES:")
            for vuln in report["vulnerabilities"]:
                print(f"\n  [{vuln['severity']}] {vuln['title']}")
                print(f"  ID: {vuln['id']}")
                print(f"  Endpoint: {vuln['endpoint']}")
                print(f"  Description: {vuln['description']}")
                print(f"  Remediation: {vuln['remediation']}")
        
        print("\n" + "=" * 60)
        
        # Exit with error code if critical vulnerabilities found
        if report["status"] == "CRITICAL":
            print("\n🚨 CRITICAL VULNERABILITIES DETECTED")
            print("Recommendation: Halt deployment and fix immediately")
            sys.exit(1)
        else:
            print("\n✓ Security scan passed")
            sys.exit(0)

if __name__ == "__main__":
    main()
