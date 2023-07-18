class Favorite {
  final String image;
  final String name;
  final String phone; 
  final int id;

  Favorite({
    required this.image,
    required this.name,
    required this.phone,
    required this.id
    
  });
}

final favorites = [
  Favorite(
    image: 'assets/8.jpg',
    name: 'هرات',
    phone: '0790129920',
    id: 1,
    
  ),
  Favorite(
    image: 'assets/9.jpg',
    name: 'کابل',
    phone: '0790129920',
    id: 2,

  ),
  Favorite(
    image: 'assets/10.jpg',
    name: 'مزار شریف',
    phone: '0790129920',
    id: 3,
  ),
  Favorite(
    image: 'assets/11.jpg',
    name: 'زابل',
    phone: '0790129920',
    id: 4,
    
  ),
  Favorite(
    image: 'assets/12.jpg',
    name: 'خوست',
    phone: '0790129920',
    id: 5,
  
  ),
  Favorite(
    image: 'assets/13.jpg',
    name: 'فراه',
    phone: '0790129920',
    id: 6,

  ),
];
