
React = require('react')

AppLayer = React.createClass ->
  render: -> 
    (div {}, ['This is my applayer'])
  

React.render(
  <AppLayer />,
  document.getElementById('content')
);

