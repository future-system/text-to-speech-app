enum TTsGoogleParamLanguage {
  afZA,
  amET,
  arXA,
  bnIN,
  euES,
  bgBG,
  yueHK,
  caES,
  cmnCN,
  cmnTW,
  csCZ,
  daDK,
  nlBE,
  nlNL,
  enAU,
  enIN,
  enGB,
  enUS,
  etEE,
  filPH,
  fiFI,
  frCA,
  frFR,
  glES,
  deDE,
  elGR,
  guIN,
  heIL,
  hiIN,
  huHU,
  isIS,
  idID,
  itIT,
  jaJP,
  knIN,
  koKR,
  lvLV,
  ltLT,
  msMY,
  mlIN,
  mrIN,
  nbNO,
  plPL,
  ptBR,
  ptPT,
  paIN,
  roRO,
  ruRU,
  srRS,
  skSK,
  esES,
  esUS,
  svSE,
  taIN,
  teIN,
  thTH,
  trTR,
  ukUA,
  urIN,
  viVN;

  //ptBR -> pt-BR
  String getLanguage() {
    final String lang = name;

    return "${lang.substring(0, 2)}-${lang.substring(2)}";
  }

  //pt-BR ou ptBR -> ptBR (ENUM)
  static TTsGoogleParamLanguage getEnum(String language) {
    final String lang = language;
    final String langToCompare = lang.replaceAll("-", "");

    return TTsGoogleParamLanguage.values.firstWhere((element) => element.name == langToCompare);
  }
}
