import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/post_bloc/bloc.dart';
import '../blocs/post_bloc/post_bloc.dart';
import '../models/user.dart';
import '../widgets/post_widget.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _filterTextEditController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PostBloc postBloc;

  @override
  void initState() {
    super.initState();
    _filterTextEditController.addListener(_onFilerChanged);
    postBloc = BlocProvider.of<PostBloc>(context)..add(LoadPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 9),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 600,
                  height: MediaQuery.of(context).size.height / 15,
                  child: TextField(
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                    controller: _filterTextEditController,
                    onSubmitted: (_) => _onFilterSubmitted(),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.5,
                            style: BorderStyle.solid),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.5,
                            style: BorderStyle.solid),
                      ),
                      contentPadding: EdgeInsets.only(top: 4),
                      hintText: 'Search posts ex: @micheline or #lol',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).size.width > 576
                ? const EdgeInsets.all(16.0)
                : const EdgeInsets.only(top: 8),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 16),
              Container(
                  width: 400,
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is AllPostsLoading ||
                          state is PostUploading ||
                          state is PostUploaded) {
                        return Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            ),
                          ),
                        );
                      } else if (state is AllPostsLoaded) {
                        return ListView.builder(
                            itemCount: state.posts.length,
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return PostWidget(post: state.posts[index]);
                            });
                      } else {
                        return Text('Please Check your internet Connection');
                      }
                    },
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  void _onFilterSubmitted() {
    postBloc.add(FilterChanged(filter: _filterTextEditController.text));
  }

  void _onFilerChanged() {
    if (_filterTextEditController.text == '') {
      BlocProvider.of<PostBloc>(context).add(LoadPosts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _filterTextEditController.dispose();
    super.dispose();
  }
}
