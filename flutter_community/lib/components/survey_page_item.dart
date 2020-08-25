
class SurveyModel{

  String id;
  String title;
  String voteType;
  String sysOrgCode;
  String sysOrgCode_dictText;
  int hits;
  int participantCount;
  String certification;
  String createDate;

  SurveyModel.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    title = json['title'],
    voteType = json['voteType'],
    sysOrgCode = json['sysOrgCode'],
    sysOrgCode_dictText = json['sysOrgCode_dictText'],
    hits = json['hits']??0,
    participantCount = json['participantCount']??0,
    certification = json['certification'],
    createDate = json['createDate'];

}