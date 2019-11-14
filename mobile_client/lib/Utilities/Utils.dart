
getOrThrow(Map<String, dynamic> map, Object mapKey) {
  if(map.containsKey(mapKey) == false)
    throw("${mapKey.toString()} field is missing in provided map: \n ${map.toString()}");
  else return map[mapKey];
}