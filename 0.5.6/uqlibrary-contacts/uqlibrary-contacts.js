(function () {
  Polymer('uqlibrary-contacts', {
    data: [
      {
        'icon': 'communication:email',
        'title': 'Email',
        'link': 'mailto:ask@library.uq.edu.au',
        'name': 'ask@library.uq.edu.au'
      },
      {
        'icon': 'communication:phone',
        'title': 'Phone',
        'link': 'tel:0733464312',
        'name': '(07) 3346 4312'
      },
      {
        'icon': 'face',
        'link': 'https://www.library.uq.edu.au/contacts/librarians',
        'name': 'Find your school, centre or institute librarian'
      }
    ]
  });
})();
