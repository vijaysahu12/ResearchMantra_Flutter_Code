
class GenderState {

  final String? genderValue;

  GenderState({
 this.genderValue
  });

  factory GenderState.initial() => GenderState(
        genderValue: ""
      );


  factory GenderState.update(
          String ?gender) =>
      GenderState(
      genderValue:gender
      );

}
