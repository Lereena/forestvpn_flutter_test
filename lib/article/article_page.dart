import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/news/repository.dart';
import '../theme.dart';
import '../widgets/translucent_background.dart';
import 'cubit/article_cubit.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage._();

  static Route<void> route(String articleId) {
    return MaterialPageRoute<void>(
      builder: (context) {
        final articleCubit = ArticleCubit(
          newsRepository: context.read<AbstractNewsRepository>(),
          articleId: articleId,
        );

        return BlocProvider.value(
          value: articleCubit,
          child: const ArticlePage._(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<ArticleCubit, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ArticleLoaded) {
            final theme = Theme.of(context);

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _ArticleHeaderWidget(article: state.article),
                      AppTheme.verticalSpacing,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Text(
                          state.article.description ?? '',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      AppTheme.verticalSpacing,
                    ],
                  ),
                ),
                const Positioned(top: 64, child: _BackButton()),
              ],
            );
          }

          return const Text('Error');
        },
      ),
    );
  }
}

class _ArticleHeaderWidget extends StatelessWidget {
  final Article article;

  const _ArticleHeaderWidget({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.network(
                article.imageUrl,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.error,
                    color: theme.colorScheme.error,
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            child: TranslucentBackground(
              child: Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.cardHeadlineTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(2),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.arrow_back_ios),
      ),
      splashRadius: 2,
      color: Colors.white,
      onPressed: () => Navigator.pop(context),
    );
  }
}
