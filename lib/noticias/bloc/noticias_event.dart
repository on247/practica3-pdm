part of 'noticias_bloc.dart';

abstract class NoticiasEvent extends Equatable {
  const NoticiasEvent();

  @override
  List<Object> get props => [];
}

class GetNewsEvent extends NoticiasEvent {}

class SearchEvent extends NoticiasEvent {
  final String query;
  SearchEvent({@required this.query});
  @override
  List<Object> get props => [query];
}
