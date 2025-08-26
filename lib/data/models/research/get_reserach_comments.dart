    
      
class ResearchMessage {
final int? id;
final String? message;
final String? modifiedBy;
final String? modifiedOn;
final String?publicKey;
const ResearchMessage({this.id , this.message , this.modifiedBy , this.modifiedOn,this.publicKey });
ResearchMessage copyWith({int? id, String? message, String? modifiedBy, String? modifiedOn,String ?publicKey}){
return ResearchMessage(
            id:id ?? this.id,
message:message ?? this.message,
modifiedBy:modifiedBy ?? this.modifiedBy,
modifiedOn:modifiedOn ?? this.modifiedOn,
publicKey: publicKey?? this.publicKey
        );
        }
        
Map<String,Object?> toJson(){
    return {
            'id': id,
'message': message,
'modifiedBy': modifiedBy,
'modifiedOn': modifiedOn,
'publicKey':publicKey,
    };
}

static ResearchMessage fromJson(Map<String , Object?> json){
    return ResearchMessage(
            id:json['id'] == null ? null : json['id'] as int,
message:json['message'] == null ? null : json['message'] as String,
modifiedBy:json['modifiedBy'] == null ? null : json['modifiedBy'] as String,
modifiedOn:json['modifiedOn'] == null ? null : json['modifiedOn'] as String,
publicKey: json['publicKey']==null?null:json['publicKey'] as String,
    );
}

    
}
      
      
  
     