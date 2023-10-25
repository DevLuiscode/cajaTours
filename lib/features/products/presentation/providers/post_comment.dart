import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

class CommentFormState {
  final bool isPosting;
  final bool isValid;
  final String idDest;
  final String idUser;
  final String commentText;

  CommentFormState({
    this.isPosting = false,
    this.isValid = false,
    this.commentText = '',
    this.idDest = '',
    this.idUser = '',
  });

  CommentFormState copyWith({
    bool? isPosting,
    bool? isValid,
    String? idDest,
    String? idUser,
    String? commentText,
  }) =>
      CommentFormState(
        isPosting: isPosting ?? this.isPosting,
        isValid: isValid ?? this.isValid,
        commentText: commentText ?? this.commentText,
        idDest: idDest ?? this.idDest,
        idUser: idUser ?? this.idUser,
      );
}

class CommentFormNotifier extends StateNotifier<CommentFormState> {
  final Function(String, String, String) postCommentCallback;
  final Function(String) deleteCommentCallback;
  CommentFormNotifier({
    required this.postCommentCallback,
    required this.deleteCommentCallback,
  }) : super(CommentFormState());

  onCommentTextChange(String idDestin, String idUser, String comment) {
    final newCommentText = comment;
    final idDestn = idDestin;
    final idUse = idUser;

    state = state.copyWith(
      commentText: newCommentText,
      idDest: idDestn,
      idUser: idUse,
      isValid: newCommentText.isNotEmpty,
    );
  }

  deleteComment(String idComment) async {
    await deleteCommentCallback(idComment);
  }

  onFormSubmit() async {
    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await postCommentCallback(
      state.commentText,
      state.idDest,
      state.idUser,
    );

    state = state.copyWith(
      isPosting: false,
      commentText: '', // Limpiar el campo de comentario después de enviar
    );
  }
}

// Proveedor para el formulario de comentarios
final commentFormProvider =
    StateNotifierProvider<CommentFormNotifier, CommentFormState>((ref) {
  final postComment = ref.watch(productsRepositoryProvider).postComment;
  final deteletComment = ref.watch(productsRepositoryProvider).deleteComment;

  return CommentFormNotifier(
      postCommentCallback: postComment, deleteCommentCallback: deteletComment);
});
// final deleteProvider =
//     StateNotifierProvider<CommentFormNotifier, CommentFormState>((ref) {
//   final postComment = ref.watch(productsRepositoryProvider).deleteComment;

//   return CommentFormNotifier(postCommentCallback: postComment);
// });
