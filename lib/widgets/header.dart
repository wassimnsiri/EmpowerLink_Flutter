import 'package:flutter/material.dart';
import '../../utils/media_query_values.dart';
import 'search_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatefulWidget {
  const Header({Key? key});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.28,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          image: AssetImage('assets/images/header_image.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloudy_snowing,
              ),
              SizedBox(
                width: context.width * 0.01,
              ),
              Text(
                'Sun, 4 June 2023',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey[200]),
              ),
            ],
          ),
          const SearchFormField(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.nights_stay,
              ),
              SizedBox(
                width: context.width * 0.01,
              ),
              const Icon(
                Icons.mic,
              ),
              SizedBox(
                width: context.width * 0.01,
              ),
              const Icon(
                Icons.notifications,
              ),
              SizedBox(
                width: context.width * 0.01,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 20.0,
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun10-1.fna.fbcdn.net/v/t39.30808-6/358426639_799581811947952_4902984929116745001_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=UiyshjhPW5UAX9tp8Be&_nc_ht=scontent.ftun10-1.fna&oh=00_AfCoYYKEkwGDGh_CbsIVQzTsMrdFkVZRH0k81yipAJxhAw&oe=65712B2B',
                      ),
                  ),
                  SizedBox(
                    width: context.width * 0.007,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            username, // Afficher le nom d'utilisateur récupéré
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: context.width * 0.005,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 12.0,
                          ),
                        ],
                      ),
                      Text(
                        email, // Afficher l'e-mail récupéré
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
