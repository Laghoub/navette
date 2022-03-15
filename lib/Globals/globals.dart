class GlobalVarsSingleton{

  String env;
  String mob;
  

  static final GlobalVarsSingleton _GlobalVarssingleton = GlobalVarsSingleton._internal();

  factory GlobalVarsSingleton() {
    return _GlobalVarssingleton;
  }
  
  GlobalVarsSingleton._internal();
}