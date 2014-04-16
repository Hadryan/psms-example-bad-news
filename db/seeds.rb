news = [
  'Nunc lobortis metus non erat interdum dictum.',
  'Aliquam eget eros fermentum, lobortis arcu ac, ornare lectus.',
  'Vestibulum ac ante pulvinar, lacinia odio eu, blandit dui.',
  'Cras ut eros vitae leo placerat facilisis quis volutpat urna.',
  'Maecenas et sapien sit amet erat eleifend imperdiet.',
  'Sed volutpat lorem volutpat, venenatis lacus non, egestas metus.',
  'Donec nec mauris laoreet, iaculis ipsum eu, facilisis ipsum.',
  'Sed in sapien nec dui sagittis sagittis sit amet ac risus.',
  'Pellentesque dapibus enim et purus commodo sagittis.',
  'Quisque sodales mauris convallis odio condimentum, eu venenatis neque imperdiet.',
  'Nunc ut nibh sed sapien scelerisque suscipit.',
  'Donec interdum elit sit amet ligula pellentesque, a sollicitudin massa mattis.',
  'Pellentesque fringilla orci at mauris molestie pellentesque.'
]

news.each { |text| News.create!(body: text) }
