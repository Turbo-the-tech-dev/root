import React from 'react';
import './MyComponent.css';

interface MyComponentProps {
  title?: string;
}

const MyComponent: React.FC<MyComponentProps> = ({ title = 'Default Title' }) => {
  return (
    <div className="my-component">
      <h1>{title}</h1>
      <p>This is MyComponent.</p>
    </div>
  );
};

export default MyComponent;
