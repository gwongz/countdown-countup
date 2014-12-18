React = require 'react'

AppLayer = React.createClass 
  render: -> 
    <div className="appLayer">
      <p>This is my app layer.</p>
    </div>
  

React.render(
  <AppLayer />,
  document.getElementById('content')
);

