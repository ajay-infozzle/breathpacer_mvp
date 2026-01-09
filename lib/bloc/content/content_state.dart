part of 'content_cubit.dart';

sealed class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

final class ContentInitial extends ContentState {}
final class ContentLoading extends ContentState {}
final class ContentLoaded extends ContentState {}
final class ContentLoadingError extends ContentState {
  final String error ;
  const ContentLoadingError(this.error);

  // @override
  // List<Object?> get props => [error];
}
