#!/bin/bash

# Verdex App Test Runner Script
# This script runs all tests in the proper order and generates a comprehensive report

set -e  # Exit on any error

echo "🚀 Verdex App Test Suite"
echo "=========================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
print_status "Checking prerequisites..."

if ! command_exists flutter; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

if ! command_exists dart; then
    print_error "Dart is not installed or not in PATH"
    exit 1
fi

print_success "Prerequisites check passed"

# Get Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
print_status "Using $FLUTTER_VERSION"

# Change to the frontend directory
cd "$(dirname "$0")"

# Clean and get dependencies
print_status "Getting dependencies..."
flutter clean
flutter pub get

# Generate mocks if needed
print_status "Generating mock files..."
flutter packages pub run build_runner build --delete-conflicting-outputs || print_warning "Mock generation failed, continuing..."

# Initialize test results
declare -A test_results
total_tests=0
passed_tests=0

# Function to run test category
run_test_category() {
    local category=$1
    local test_path=$2
    local description=$3
    
    print_status "Running $description..."
    
    if flutter test "$test_path" --reporter=compact; then
        test_results[$category]=true
        passed_tests=$((passed_tests + 1))
        print_success "$description completed successfully"
    else
        test_results[$category]=false
        print_error "$description failed"
    fi
    
    total_tests=$((total_tests + 1))
    echo ""
}

# Run all test categories
echo "📋 Running Test Categories"
echo "=========================="

# Unit Tests
run_test_category "unit_tests" "test/services/" "Service Unit Tests"
run_test_category "unit_utils" "test/unit/" "Utility Unit Tests"

# Widget Tests
run_test_category "widget_screens" "test/screens/" "Screen Widget Tests"
run_test_category "widget_components" "test/widgets/" "Component Widget Tests"

# Integration Tests
run_test_category "integration_tests" "test/integration/" "Integration Tests"

# Specialized Tests
run_test_category "performance_tests" "test/performance/" "Performance Tests"
run_test_category "security_tests" "test/security/" "Security Tests"
run_test_category "accessibility_tests" "test/accessibility/" "Accessibility Tests"

# Generate test report
echo "📊 Test Report"
echo "=============="

for category in "${!test_results[@]}"; do
    if [[ "${test_results[$category]}" == true ]]; then
        echo -e "${GREEN}✅ $category: PASSED${NC}"
    else
        echo -e "${RED}❌ $category: FAILED${NC}"
    fi
done

echo ""
echo "📈 Summary"
echo "=========="
echo "Total test categories: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $((total_tests - passed_tests))"

if [[ $passed_tests -eq $total_tests ]]; then
    success_rate=100
else
    success_rate=$((passed_tests * 100 / total_tests))
fi

echo "Success rate: ${success_rate}%"

# Final status
echo ""
if [[ $passed_tests -eq $total_tests ]]; then
    echo -e "${GREEN}🎉 All tests passed! The app is ready for production.${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed. Please review and fix the issues.${NC}"
    exit 1
fi 