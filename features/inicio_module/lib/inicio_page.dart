import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Image of a ferret (assuming "hurones" refers to ferrets)
          Image(
            image: const AssetImage(
                'assets/images/huron.jpg'), // Replace with your image path
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          const SizedBox(height: 16), // Spacing between image and text
          // Lorem Ipsum text about ferrets
          const Text('''
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
          Maecenas nec odio et ante euismod elementum. 
          Donec euismod bibendum laoreet. 
          Proin gravida dolor quis diam pulvinar vitae malesuada nunc bibendum. 
          Nunc eu augue suscipit, rutrum neque eu, semper eros. 
      
          Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; 
          Donec velit erat. 
          Aenean eu leo quam. 
          Pellentesque ornare sem lacinia quam venenatis vestibulum. 
          Sed posuere consectetur est at lobortis.
      
          Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, 
          ut fermentum massa justo sit amet magna. 
          Sed ipsum. 
          Donec placerat nibh ante. 
          Fusce ultricies pede quis odio consequat varius. 
      
          Morbi leo risus, porta ac consectetur ac, vestibulum at eros. 
          Vestibulum id ligula porta felis euismod semper. 
          Cum sociis natoque penatibus et magnis dis parturient montes, 
          nascetur ridiculus mus. 
      
          Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. 
          Donec ullamcorper nulla non metus auctor fringilla. 
          Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
          '''),
        ],
      ),
    );
  }
}
