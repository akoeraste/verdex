import 'package:flutter_test/flutter_test.dart';
import 'package:verdex/utils/validation_utils.dart';
import 'package:verdex/utils/image_utils.dart';
import 'package:verdex/utils/date_utils.dart';
import 'package:verdex/utils/string_utils.dart';

void main() {
  group('Validation Utils Tests', () {
    group('Email Validation', () {
      test('should validate correct email addresses', () {
        expect(ValidationUtils.isValidEmail('test@example.com'), isTrue);
        expect(ValidationUtils.isValidEmail('user.name@domain.co.uk'), isTrue);
        expect(ValidationUtils.isValidEmail('test+tag@example.org'), isTrue);
      });

      test('should reject invalid email addresses', () {
        expect(ValidationUtils.isValidEmail('invalid-email'), isFalse);
        expect(ValidationUtils.isValidEmail('test@'), isFalse);
        expect(ValidationUtils.isValidEmail('@example.com'), isFalse);
        expect(ValidationUtils.isValidEmail('test@.com'), isFalse);
        expect(ValidationUtils.isValidEmail(''), isFalse);
        expect(ValidationUtils.isValidEmail(null), isFalse);
      });

      test('should handle edge cases', () {
        expect(ValidationUtils.isValidEmail('test@example'), isFalse);
        expect(ValidationUtils.isValidEmail('test.example.com'), isFalse);
        expect(ValidationUtils.isValidEmail('test@example..com'), isFalse);
      });
    });

    group('Password Validation', () {
      test('should validate strong passwords', () {
        expect(ValidationUtils.isValidPassword('Password123!'), isTrue);
        expect(ValidationUtils.isValidPassword('MySecurePass1'), isTrue);
        expect(ValidationUtils.isValidPassword('1234567890Ab'), isTrue);
      });

      test('should reject weak passwords', () {
        expect(ValidationUtils.isValidPassword('123'), isFalse); // Too short
        expect(
          ValidationUtils.isValidPassword('password'),
          isFalse,
        ); // No uppercase
        expect(
          ValidationUtils.isValidPassword('PASSWORD'),
          isFalse,
        ); // No lowercase
        expect(
          ValidationUtils.isValidPassword('Password'),
          isFalse,
        ); // No number
        expect(ValidationUtils.isValidPassword(''), isFalse);
        expect(ValidationUtils.isValidPassword(null), isFalse);
      });

      test('should check minimum length', () {
        expect(
          ValidationUtils.isValidPassword('Pass1'),
          isFalse,
        ); // Less than 6 chars
        expect(
          ValidationUtils.isValidPassword('Pass12'),
          isTrue,
        ); // Exactly 6 chars
        expect(
          ValidationUtils.isValidPassword('Password123'),
          isTrue,
        ); // More than 6 chars
      });
    });

    group('Name Validation', () {
      test('should validate correct names', () {
        expect(ValidationUtils.isValidName('John'), isTrue);
        expect(ValidationUtils.isValidName('Mary Jane'), isTrue);
        expect(ValidationUtils.isValidName('O\'Connor'), isTrue);
        expect(ValidationUtils.isValidName('José'), isTrue);
      });

      test('should reject invalid names', () {
        expect(ValidationUtils.isValidName(''), isFalse);
        expect(ValidationUtils.isValidName('123'), isFalse);
        expect(ValidationUtils.isValidName('John123'), isFalse);
        expect(ValidationUtils.isValidName(null), isFalse);
      });

      test('should handle special characters', () {
        expect(ValidationUtils.isValidName('Jean-Pierre'), isTrue);
        expect(ValidationUtils.isValidName('Mary-Jane'), isTrue);
        expect(ValidationUtils.isValidName('O\'Brien'), isTrue);
      });
    });

    group('URL Validation', () {
      test('should validate correct URLs', () {
        expect(ValidationUtils.isValidUrl('https://example.com'), isTrue);
        expect(ValidationUtils.isValidUrl('http://test.org'), isTrue);
        expect(ValidationUtils.isValidUrl('https://sub.domain.co.uk'), isTrue);
      });

      test('should reject invalid URLs', () {
        expect(ValidationUtils.isValidUrl('not-a-url'), isFalse);
        expect(ValidationUtils.isValidUrl('ftp://example.com'), isFalse);
        expect(ValidationUtils.isValidUrl(''), isFalse);
        expect(ValidationUtils.isValidUrl(null), isFalse);
      });
    });
  });

  group('Image Utils Tests', () {
    group('Image Format Validation', () {
      test('should validate correct image formats', () {
        expect(ImageUtils.isValidImageFormat('image.jpg'), isTrue);
        expect(ImageUtils.isValidImageFormat('photo.png'), isTrue);
        expect(ImageUtils.isValidImageFormat('picture.jpeg'), isTrue);
        expect(ImageUtils.isValidImageFormat('image.webp'), isTrue);
      });

      test('should reject invalid image formats', () {
        expect(ImageUtils.isValidImageFormat('document.pdf'), isFalse);
        expect(ImageUtils.isValidImageFormat('video.mp4'), isFalse);
        expect(ImageUtils.isValidImageFormat('image.txt'), isFalse);
        expect(ImageUtils.isValidImageFormat(''), isFalse);
        expect(ImageUtils.isValidImageFormat(null), isFalse);
      });
    });

    group('Image Size Validation', () {
      test('should validate acceptable image sizes', () {
        expect(ImageUtils.isValidImageSize(1024 * 1024), isTrue); // 1MB
        expect(ImageUtils.isValidImageSize(5 * 1024 * 1024), isTrue); // 5MB
        expect(ImageUtils.isValidImageSize(10 * 1024 * 1024), isTrue); // 10MB
      });

      test('should reject oversized images', () {
        expect(ImageUtils.isValidImageSize(15 * 1024 * 1024), isFalse); // 15MB
        expect(ImageUtils.isValidImageSize(50 * 1024 * 1024), isFalse); // 50MB
      });

      test('should reject zero or negative sizes', () {
        expect(ImageUtils.isValidImageSize(0), isFalse);
        expect(ImageUtils.isValidImageSize(-1024), isFalse);
      });
    });

    group('Image Compression', () {
      test('should calculate compression quality correctly', () {
        expect(
          ImageUtils.calculateCompressionQuality(1024 * 1024),
          equals(0.8),
        );
        expect(
          ImageUtils.calculateCompressionQuality(5 * 1024 * 1024),
          equals(0.6),
        );
        expect(
          ImageUtils.calculateCompressionQuality(10 * 1024 * 1024),
          equals(0.4),
        );
      });

      test('should return minimum quality for large images', () {
        expect(
          ImageUtils.calculateCompressionQuality(20 * 1024 * 1024),
          equals(0.2),
        );
        expect(
          ImageUtils.calculateCompressionQuality(50 * 1024 * 1024),
          equals(0.2),
        );
      });
    });

    group('Image Dimensions', () {
      test('should validate acceptable dimensions', () {
        expect(ImageUtils.isValidDimensions(800, 600), isTrue);
        expect(ImageUtils.isValidDimensions(1920, 1080), isTrue);
        expect(ImageUtils.isValidDimensions(4000, 3000), isTrue);
      });

      test('should reject extreme dimensions', () {
        expect(ImageUtils.isValidDimensions(10000, 10000), isFalse);
        expect(ImageUtils.isValidDimensions(100, 100), isFalse);
        expect(ImageUtils.isValidDimensions(0, 0), isFalse);
        expect(ImageUtils.isValidDimensions(-100, -100), isFalse);
      });
    });
  });

  group('Date Utils Tests', () {
    group('Date Formatting', () {
      test('should format dates correctly', () {
        final date = DateTime(2023, 12, 25, 14, 30, 0);
        expect(DateUtils.formatDate(date), equals('Dec 25, 2023'));
        expect(DateUtils.formatDateTime(date), equals('Dec 25, 2023 2:30 PM'));
      });

      test('should handle different date formats', () {
        final date = DateTime(2023, 1, 1, 9, 15, 0);
        expect(DateUtils.formatDate(date), equals('Jan 1, 2023'));
        expect(DateUtils.formatDateTime(date), equals('Jan 1, 2023 9:15 AM'));
      });

      test('should handle null dates', () {
        expect(DateUtils.formatDate(null), equals('N/A'));
        expect(DateUtils.formatDateTime(null), equals('N/A'));
      });
    });

    group('Relative Time', () {
      test('should show relative time correctly', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(const Duration(hours: 1));
        final oneDayAgo = now.subtract(const Duration(days: 1));
        final oneWeekAgo = now.subtract(const Duration(days: 7));

        expect(DateUtils.getRelativeTime(oneHourAgo), contains('hour'));
        expect(DateUtils.getRelativeTime(oneDayAgo), contains('day'));
        expect(DateUtils.getRelativeTime(oneWeekAgo), contains('week'));
      });

      test('should handle future dates', () {
        final now = DateTime.now();
        final oneHourLater = now.add(const Duration(hours: 1));
        final oneDayLater = now.add(const Duration(days: 1));

        expect(DateUtils.getRelativeTime(oneHourLater), contains('hour'));
        expect(DateUtils.getRelativeTime(oneDayLater), contains('day'));
      });
    });

    group('Date Comparison', () {
      test('should compare dates correctly', () {
        final date1 = DateTime(2023, 1, 1);
        final date2 = DateTime(2023, 1, 2);
        final date3 = DateTime(2023, 1, 1);

        expect(DateUtils.isSameDay(date1, date3), isTrue);
        expect(DateUtils.isSameDay(date1, date2), isFalse);
        expect(DateUtils.isToday(date1), isFalse);
      });

      test('should identify today correctly', () {
        final today = DateTime.now();
        expect(DateUtils.isToday(today), isTrue);

        final yesterday = today.subtract(const Duration(days: 1));
        expect(DateUtils.isToday(yesterday), isFalse);
      });
    });

    group('Date Parsing', () {
      test('should parse valid date strings', () {
        expect(DateUtils.parseDate('2023-12-25'), isNotNull);
        expect(DateUtils.parseDate('2023/12/25'), isNotNull);
        expect(DateUtils.parseDate('25-12-2023'), isNotNull);
      });

      test('should handle invalid date strings', () {
        expect(DateUtils.parseDate('invalid-date'), isNull);
        expect(DateUtils.parseDate(''), isNull);
        expect(DateUtils.parseDate(null), isNull);
      });
    });
  });

  group('String Utils Tests', () {
    group('Text Truncation', () {
      test('should truncate long text correctly', () {
        const longText =
            'This is a very long text that should be truncated when it exceeds the maximum length';
        const maxLength = 20;

        final truncated = StringUtils.truncate(longText, maxLength);
        expect(
          truncated.length,
          lessThanOrEqualTo(maxLength + 3),
        ); // +3 for "..."
        expect(truncated, endsWith('...'));
      });

      test('should not truncate short text', () {
        const shortText = 'Short text';
        const maxLength = 20;

        final result = StringUtils.truncate(shortText, maxLength);
        expect(result, equals(shortText));
        expect(result, isNot(endsWith('...')));
      });

      test('should handle empty or null text', () {
        expect(StringUtils.truncate('', 10), equals(''));
        expect(StringUtils.truncate(null, 10), equals(''));
      });
    });

    group('Text Capitalization', () {
      test('should capitalize text correctly', () {
        expect(StringUtils.capitalize('hello world'), equals('Hello world'));
        expect(StringUtils.capitalize('HELLO WORLD'), equals('Hello world'));
        expect(StringUtils.capitalize('hello'), equals('Hello'));
      });

      test('should handle edge cases', () {
        expect(StringUtils.capitalize(''), equals(''));
        expect(StringUtils.capitalize(null), equals(''));
        expect(StringUtils.capitalize('a'), equals('A'));
      });
    });

    group('Text Cleaning', () {
      test('should remove extra whitespace', () {
        expect(
          StringUtils.cleanText('  hello   world  '),
          equals('hello world'),
        );
        expect(
          StringUtils.cleanText('\nhello\tworld\n'),
          equals('hello world'),
        );
      });

      test('should handle special characters', () {
        expect(
          StringUtils.cleanText('hello@world.com'),
          equals('hello@world.com'),
        );
        expect(StringUtils.cleanText('hello-world'), equals('hello-world'));
        expect(StringUtils.cleanText('hello_world'), equals('hello_world'));
      });
    });

    group('Text Validation', () {
      test('should validate non-empty text', () {
        expect(StringUtils.isNotEmpty('hello'), isTrue);
        expect(StringUtils.isNotEmpty(''), isFalse);
        expect(StringUtils.isNotEmpty(null), isFalse);
        expect(StringUtils.isNotEmpty('   '), isFalse);
      });

      test('should validate text length', () {
        expect(StringUtils.isValidLength('hello', 3, 10), isTrue);
        expect(StringUtils.isValidLength('hi', 3, 10), isFalse);
        expect(StringUtils.isValidLength('hello world', 3, 10), isFalse);
      });
    });

    group('Text Search', () {
      test('should find text matches', () {
        const text = 'Hello world, this is a test';
        expect(StringUtils.containsIgnoreCase(text, 'hello'), isTrue);
        expect(StringUtils.containsIgnoreCase(text, 'WORLD'), isTrue);
        expect(StringUtils.containsIgnoreCase(text, 'test'), isTrue);
        expect(StringUtils.containsIgnoreCase(text, 'missing'), isFalse);
      });

      test('should handle edge cases', () {
        expect(StringUtils.containsIgnoreCase('', 'test'), isFalse);
        expect(StringUtils.containsIgnoreCase('hello', ''), isTrue);
        expect(StringUtils.containsIgnoreCase(null, 'test'), isFalse);
        expect(StringUtils.containsIgnoreCase('hello', null), isFalse);
      });
    });

    group('Text Formatting', () {
      test('should format numbers correctly', () {
        expect(StringUtils.formatNumber(1000), equals('1,000'));
        expect(StringUtils.formatNumber(1000000), equals('1,000,000'));
        expect(StringUtils.formatNumber(123.456), equals('123.46'));
      });

      test('should format file sizes', () {
        expect(StringUtils.formatFileSize(1024), equals('1.0 KB'));
        expect(StringUtils.formatFileSize(1024 * 1024), equals('1.0 MB'));
        expect(
          StringUtils.formatFileSize(1024 * 1024 * 1024),
          equals('1.0 GB'),
        );
      });

      test('should format percentages', () {
        expect(StringUtils.formatPercentage(0.1234), equals('12.34%'));
        expect(StringUtils.formatPercentage(1.0), equals('100.00%'));
        expect(StringUtils.formatPercentage(0.0), equals('0.00%'));
      });
    });
  });
}
