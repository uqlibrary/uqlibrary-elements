/**
 * Created by uqckorte on 28/01/15.
 */
function checkMenu(readyMenu) {
  var myName = readyMenu.shadowRoot.getElementById('name');
  expect(myName.innerHTML).to.contain('John Doe');
  var myId = readyMenu.shadowRoot.querySelector('paper-item#showHoursPage');
  expect(myId.innerHTML).to.contain('Hours');
}