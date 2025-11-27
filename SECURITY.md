# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.4.x   | :white_check_mark: |
| < 1.4   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly. We appreciate your help in keeping our users safe.

### How to Report

1. **Do not create public issues** for security vulnerabilities
2. Email the maintainers at [security@example.com] (replace with actual contact)
3. Include detailed information about the vulnerability:
   - Description of the issue
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response Timeline

- **Acknowledgment**: Within 48 hours
- **Investigation**: Within 7 days
- **Fix Development**: Within 30 days for critical issues
- **Public Disclosure**: After fix is deployed and tested

## Security Measures

This repository implements several security measures:

- **Automated Security Scanning**: CodeQL and Trivy scans on every push
- **Pre-commit Security Checks**: Bandit, Safety, and other security linters
- **Git Hook Enforcement**: Commit validation and author verification
- **Dependency Monitoring**: Automated updates via Dependabot

## Responsible Disclosure

We follow responsible disclosure practices. Once a vulnerability is reported:

1. We'll acknowledge receipt
2. Investigate and validate the issue
3. Develop and test a fix
4. Coordinate public disclosure with the reporter
5. Apply the fix and release an update

Thank you for helping keep our project secure!