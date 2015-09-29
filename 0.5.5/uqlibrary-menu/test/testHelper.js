/**
 * Created by uqckorte on 28/01/15.
 */
function checkMenu(readyMenu) {

  var myName = readyMenu.shadowRoot.getElementById('name');
  expect(myName.innerHTML).to.contain('Mr. John Doe');

  var myId = readyMenu.shadowRoot.querySelector('paper-item#uqlibrary-hours');
  expect(myId.innerHTML).to.contain('Hours');

}