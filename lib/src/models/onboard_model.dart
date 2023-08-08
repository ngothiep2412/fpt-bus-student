class OnboardModel {
  String img;
  String text;
  String desc;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
  });
}

List<OnboardModel> screens = <OnboardModel>[
  OnboardModel(
    img: 'onboard-1.png',
    text: "Book your onlinebus ticket",
    desc: "Developed by group students",
  ),
  OnboardModel(
    img: 'onboard-2.png',
    text: "Digital Bus Management System",
    desc: "Developed by group students",
  ),
  OnboardModel(
    img: 'onboard-3.png',
    text: "Stay updated with brief notifications",
    desc: "Developed by group students",
  ),
];
