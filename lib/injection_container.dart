
/*
import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/wallet/data/datasources/wallet_local_data_source.dart';
import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';
import 'features/wallet/domain/usecases/add_transaction.dart';
import 'features/wallet/domain/usecases/get_balance.dart';
import 'features/wallet/domain/usecases/get_transactions.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------------------
  // AUTH FEATURE
  // -------------------

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    local: sl<AuthLocalDataSource>(),
    remote: sl<AuthRemoteDataSource>(),
  ));

  // BLoC
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // -------------------
  // WALLET FEATURE
  // -------------------

  // Local data source
  sl.registerLazySingleton<WalletLocalDataSource>(() => WalletLocalDataSource());

  // Repository
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(
    localDataSource: sl<WalletLocalDataSource>(),
    remoteDataSource: sl<WalletRemoteDataSource>(),
  ));

  // BLoC
  sl.registerFactory(() => WalletBloc(
    getBalanceUseCase: sl<GetBalance>(),
    getTransactionsUseCase: sl<GetTransactions>(),
    addTransactionUseCase: sl<AddTransaction>(),
  ));

  // -------------------
  // Other services (Optional: NetworkInfo, TokenManager, etc.)
  // -------------------
  // Add here later if needed
}

*/
import 'package:get_it/get_it.dart';

// Auth feature
import 'core/security/secure_storage_service.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Wallet feature
import 'features/sync/data/sync_service.dart';
import 'features/sync/sync_bloc.dart';
import 'features/wallet/data/datasources/wallet_local_data_source.dart';
import 'features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';
import 'features/wallet/domain/usecases/add_transaction.dart';
import 'features/wallet/domain/usecases/get_balance.dart';
import 'features/wallet/domain/usecases/get_transactions.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

// Optional core services
import 'core/security/token_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------------------
  // CORE
  // -------------------
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<TokenManager>(() => TokenManager(sl<SecureStorageService>()));

  // -------------------
  // AUTH FEATURE
  // -------------------

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
          () => AuthLocalDataSource(tokenManager: sl<TokenManager>()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    local: sl<AuthLocalDataSource>(),
    remote: sl<AuthRemoteDataSource>(),
  ));

  // BLoC
  sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));

  // -------------------
  // WALLET FEATURE
  // -------------------

  // Data Sources
  sl.registerLazySingleton<WalletLocalDataSource>(() => WalletLocalDataSource());
  sl.registerLazySingleton<WalletRemoteDataSource>(() => WalletRemoteDataSource());

  // Repository
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(
    localDataSource: sl<WalletLocalDataSource>(),
    remoteDataSource: sl<WalletRemoteDataSource>(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetBalance(sl<WalletRepository>()));
  sl.registerLazySingleton(() => GetTransactions(sl<WalletRepository>()));
  sl.registerLazySingleton(() => AddTransaction(sl<WalletRepository>()));



  // BLoC
  sl.registerLazySingleton<SyncService>(
        () => SyncService(
      repository: sl<WalletRepository>(), // your repo
    ),
  );

// 2️⃣ Register SyncBloc
  sl.registerLazySingleton<SyncBloc>(
        () => SyncBloc(syncService: sl<SyncService>()), // pass SyncService
  );

// 3️⃣ Register WalletBloc with SyncBloc
  sl.registerFactory<WalletBloc>(() => WalletBloc(
    getBalanceUseCase: sl<GetBalance>(),
    getTransactionsUseCase: sl<GetTransactions>(),
    addTransactionUseCase: sl<AddTransaction>(),
    syncBloc: sl<SyncBloc>(), // ✅ pass SyncBloc here
  ));
}