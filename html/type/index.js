document.querySelector('form').onsubmit = function() {
  console.log(this.elements.submitted);
  return false;
};
