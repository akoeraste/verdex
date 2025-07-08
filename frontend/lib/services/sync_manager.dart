import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'local_db_service.dart';
import '../constants/api_config.dart';

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  final LocalDbService _localDbService = LocalDbService();
  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  void start() {
    _sync();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _sync());
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        _sync();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _connectivitySub?.cancel();
  }

  Future<void> syncAll() async {
    await _sync();
  }

  Future<void> _sync() async {
    try {
      // Upload local changes for all tables
      final plantsToSync = await _localDbService.getPlantsNeedingSync();
      final usersToSync = await _localDbService.getUsersNeedingSync();
      final postsToSync = await _localDbService.getPostsNeedingSync();
      final categoriesToSync = await _localDbService.getCategoriesNeedingSync();
      final rolesToSync = await _localDbService.getRolesNeedingSync();
      final permissionsToSync = await _localDbService
          .getPermissionsNeedingSync();

      final uploadData = {
        'plants': plantsToSync,
        'users': usersToSync,
        'posts': postsToSync,
        'categories': categoriesToSync,
        'roles': rolesToSync,
        'permissions': permissionsToSync,
      };

      final uploadResponse = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/sync/all'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(uploadData),
      );
      if (uploadResponse.statusCode == 200) {
        for (final plant in plantsToSync) {
          await _localDbService.markPlantSynced(plant['id']);
        }
        for (final user in usersToSync) {
          await _localDbService.markUserSynced(user['id']);
        }
        for (final post in postsToSync) {
          await _localDbService.markPostSynced(post['id']);
        }
        for (final category in categoriesToSync) {
          await _localDbService.markCategorySynced(category['id']);
        }
        for (final role in rolesToSync) {
          await _localDbService.markRoleSynced(role['id']);
        }
        for (final permission in permissionsToSync) {
          await _localDbService.markPermissionSynced(permission['id']);
        }
      }

      // Download all tables from server
      final downloadResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/sync/all'),
      );
      if (downloadResponse.statusCode == 200) {
        final data = jsonDecode(downloadResponse.body);
        if (data is Map<String, dynamic>) {
          // Plants
          if (data['plants'] is List) {
            for (final plant in data['plants']) {
              await _localDbService.insertPlant(plant, needsSync: false);
            }
          }
          // Users
          if (data['users'] is List) {
            for (final user in data['users']) {
              await _localDbService.insertUser(user, needsSync: false);
            }
          }
          // Posts
          if (data['posts'] is List) {
            for (final post in data['posts']) {
              await _localDbService.insertPost(post, needsSync: false);
            }
          }
          // Categories
          if (data['categories'] is List) {
            for (final category in data['categories']) {
              await _localDbService.insertCategory(category, needsSync: false);
            }
          }
          // Roles
          if (data['roles'] is List) {
            for (final role in data['roles']) {
              await _localDbService.insertRole(role, needsSync: false);
            }
          }
          // Permissions
          if (data['permissions'] is List) {
            for (final permission in data['permissions']) {
              await _localDbService.insertPermission(
                permission,
                needsSync: false,
              );
            }
          }
        }
      }
    } catch (e) {
      // Handle errors (e.g., log or show notification)
    }
  }
}
