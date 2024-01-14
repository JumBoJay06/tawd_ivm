
enum IvmEnvironments { developer, production }

IvmConfig kIvmConfig = IvmConfig.developer();

class IvmConfig {
  IvmConfig.production() : ivmEnvironments = IvmEnvironments.production;

  IvmConfig.developer() : ivmEnvironments = IvmEnvironments.developer;

  final IvmEnvironments ivmEnvironments;
}