/**
 * Created by uqckorte on 28/01/15.
 */
function checkMenu(readyMenu) {
    console.log(readyMenu);
    //console.log(readyMenu);
  var myName = readyMenu.shadowRoot.getElementById('name');
  expect(myName.innerHTML).to.contain('Mr. John Doe');
  var myId = readyMenu.shadowRoot.querySelector('paper-item#showHoursPage');
  expect(myId.innerHTML).to.contain('Hours');
}