/**
 * https://script.google.com
 *
 * This runs automatically when the Google Sheet is opened.
 * source: https://basescripts.com/api-keys-secrets-and-secure-configuration-in-google-apps-script
 *
 * Adding X_AUTH_TOKEN in Google Apps Script
 * Go to: Project settings -> Script Properties
 * property name: X_AUTH_TOKEN
 * property value: <PUT YOUR X_AUTH_TOKEN VALUE HERE>
/*
function onOpen() {
  const ui = SpreadsheetApp.getUi();
  
  // Create a custom menu in the top toolbar
  ui.createMenu('🚀 Send to server')
    .addItem('Send Data to Server', 'sendDataToTailscale')
    .addSeparator()
    .addItem('Check Server Status', 'checkStatus') // Optional extra button
    .addToUi();
}
*/

/*
// Optional helper function to test the connection without sending a massive file
function checkStatus() {
  SpreadsheetApp.getUi().alert('Menu is working! Click "Send Data" to trigger the export.');
}
*/

/**
 * Generates a NanoID-style string.
 */
function generateNanoID(length = 12) {
  const alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-';
  let id = '';
  for (let i = 0; i < length; i++) {
    id += alphabet.charAt(Math.floor(Math.random() * alphabet.length));
  }
  return id;
}

/**
 * Automatically triggers when a user edits the sheet.
 */
function onEdit(e) {
  const sheet = e.source.getActiveSheet();
  const range = e.range;
  const row = range.getRow();
  const col = range.getColumn();

  // Settings: 
  // Column A = 1
  // Columns B through V = 2 through 22
  if (row >= 3 && col >= 2 && col <= 22) {
    const idCell = sheet.getRange(row, 1);
    
    // If ID already exists, stop immediately to prevent regeneration
    if (idCell.getValue() !== "") return;

    // Get all values from B to V for the edited row
    // getValues() returns a 2D array: [[valB, valC, ... valV]]
    const checkRange = sheet.getRange(row, 2, 1, 21).getValues()[0];

    // Check if every single cell in that range has a value
    const isRowComplete = checkRange.every(cellValue => {
      return cellValue !== "" && cellValue !== null && cellValue !== undefined;
    });

    if (isRowComplete) {
      idCell.setValue(generateNanoID(12));
    }
  }
}

function getApiKey(propertyName) {
  var props = PropertiesService.getScriptProperties();
  var key = props.getProperty(propertyName);

  if (!key) {
    throw new Error('Missing API key: ' + propertyName);
  }

  return key;
}

function sendToLocalTunnelServer() {
  // 1. Define the Spreadsheet (the whole file)
  const spread_sheet = SpreadsheetApp.getActiveSpreadsheet();
  
  // 2. Define the Sheet (the specific tab)
  const active_sheet = spread_sheet.getActiveSheet(); 
  
  // 3. Get the Owner
  const committer = spread_sheet.getOwner().getEmail();
  
  // Now you can use them!
  // Logger.log("Committer: " + committer);
  // Logger.log("Committed spreadsheet tab name: " + active_sheet.getName());

  const allData = spread_sheet.getDataRange().getDisplayValues();
  
  // allData[0]; // button, not needed here
  const headers = allData[1]; // header
  const rows = allData.slice(2); // rest of data

  const jsonPayload = rows.map(row => {
    let obj = {};
    headers.forEach((header, index) => {
      if (header !== "") {
        obj[header] = row[index];
      }
    });
    obj.committer = committer;
    return obj;
  });

  const url = "https://jaeysons-macbook-air.tail568508.ts.net/verify";

  const options = {
    method: "post",
    contentType: "application/json",
    headers: {
      "X-Auth-Token": getApiKey('X_AUTH_TOKEN')
    },
    payload: JSON.stringify(jsonPayload),
    muteHttpExceptions: true
  };

  try {
    const response = UrlFetchApp.fetch(url, options);
    const code = response.getResponseCode();
    const content = response.getContentText();

    let result = {};

    if (content && content.trim(). startsWith('{')) {
      result = JSON.parse(content);
    }

    const { ok, server_error } = result;

    Logger.log('server error: ' + server_error); // server-related or undefined
    Logger.log('ok: ' + ok);    // 9 (or undefined if missing)

    switch (code) {
      case 200:
        SpreadsheetApp.getUi().alert("💡 0 Beneficiaries added to server");
        break;
      case 201:
        SpreadsheetApp.getUi().alert(`✅ duplicates: ${0 || 0}, non-dup: ${ok || 0}, server error: ${server_error || 0}`);
        break;
      case 403:
        SpreadsheetApp.getUi().alert("❌ ✋🏽 Forbidden: needs token access");
        break;
      case 500:
        SpreadsheetApp.getUi().alert("❌ 🖥️ Server related error");
        break;
      default:
        SpreadsheetApp.getUi().alert("❌ 🛜 Error: Failed to send data. Check server error logs");
    }
  } catch (e) {
    Logger.log("Error: " + e.toString());
    SpreadsheetApp.getUi().alert("❌ Error: Failed to send data. Check Logs.");
  }
}
