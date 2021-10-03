abstract class SearchStates{}

class SearchInitState extends SearchStates{}

class SearchLoadingState extends SearchStates{}
class SearchSuccessState extends SearchStates{}
class SearchErrorState extends SearchStates{
  final String error;
  SearchErrorState(this.error);
}