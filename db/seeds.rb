news = [
  'Nunc lobortis metus non erat interdum dictum.',
  'Aliquam eget eros fermentum, lobortis arcu ac, ornare lectus.',
  'Vestibulum ac ante pulvinar, lacinia odio eu, blandit dui.',
  'Cras ut eros vitae leo placerat facilisis quis volutpat urna.'
]

news.each { |text| News.create!(body: text) }
