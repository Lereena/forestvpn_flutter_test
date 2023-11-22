import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../featured_news/featured_news_widget.dart';
import '../latest_news/cubit/latest_news_list_cubit.dart';
import '../latest_news/latest_news_widget.dart';
import '../repositories/news/repository.dart';
import '../theme.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          LatestNewsListCubit(context.read<AbstractNewsRepository>()),
      child: Scaffold(
        appBar: _NotificationsAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  'Featured',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SliverToBoxAdapter(child: AppTheme.verticalSpacing),
              const FeaturedNewsSliver(),
              const SliverToBoxAdapter(child: AppTheme.verticalSpacing),
              SliverToBoxAdapter(
                child: Text(
                  'Latest news',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SliverToBoxAdapter(child: AppTheme.verticalSpacing),
              const SliverToBoxAdapter(child: LatestNewsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsAppBar extends AppBar {
  _NotificationsAppBar({Key? key})
      : super(
          key: key,
          centerTitle: true,
          title: const Text('Notifications'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          actions: const [_MarkAllAsReadButton()],
        );
}

class _MarkAllAsReadButton extends StatelessWidget {
  const _MarkAllAsReadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'Mark all as read',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      onPressed: () =>
          context.read<LatestNewsListCubit>().markAllArticlesAsRead(),
    );
  }
}
