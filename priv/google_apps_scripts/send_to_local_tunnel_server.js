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
 */

/**
 * Clears red highlights from the data rows.
 */
function clearHighlights() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  const DATA_START_ROW = 8; // Define your data start row
  const lastRow = sheet.getLastRow();
  const lastCol = sheet.getLastColumn();
  
  // Only clear if there is actually data below or at the start row
  if (lastRow >= DATA_START_ROW) {
    // Calculate how many rows to clear: 
    // If lastRow is 10 and start is 8, we need to clear 3 rows (8, 9, 10)
    const numRowsToClear = lastRow - DATA_START_ROW + 1;
    
    sheet.getRange(DATA_START_ROW, 1, numRowsToClear, lastCol).setBackground(null);
    SpreadsheetApp.getUi().alert("Highlights cleared from row 8 downwards!");
  } else {
    SpreadsheetApp.getUi().alert("No data rows found to clear.");
  }
}

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
  const spread_sheet = SpreadsheetApp.getActiveSpreadsheet();
  const active_sheet = spread_sheet.getActiveSheet(); 
  const committer = spread_sheet.getOwner().getEmail();
  
  const HEADER_ROW = 7; 
  const DATA_START_ROW = 8;

  const allData = active_sheet.getDataRange().getDisplayValues();
  const headers = allData[HEADER_ROW - 1]; 
  const rows = allData.slice(DATA_START_ROW - 1); 

  const jsonPayload = rows.map(row => {
    let obj = {};
    headers.forEach((header, index) => {
      if (header !== "" && header !== null) {
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
    headers: { "X-Auth-Token": getApiKey('X_AUTH_TOKEN') },
    payload: JSON.stringify(jsonPayload),
    muteHttpExceptions: true
  };

  try {
    const response = UrlFetchApp.fetch(url, options);
    const code = response.getResponseCode();
    const content = response.getContentText();
    const result = JSON.parse(content); // This is the list from Elixir

    // We use reduce to count and extract duplicate IDs in one pass
    const stats = result.reduce((acc, item) => {
      if (item === "ok") {
        acc.okCount++;
      } else if (item && typeof item === 'object' && item.duplicate) {
        acc.duplicateCount++;
        acc.duplicateIds.push(item.duplicate);
      }
      return acc;
    }, { okCount: 0, duplicateCount: 0, duplicateIds: [] });

    const lastRow = active_sheet.getLastRow();
    const lastCol = active_sheet.getLastColumn();

    if (lastRow >= DATA_START_ROW) {
      // Clear previous highlights
      active_sheet.getRange(DATA_START_ROW, 1, lastRow - (DATA_START_ROW - 1), lastCol).setBackground(null);

      if (stats.duplicateIds.length > 0) {
        const idRange = active_sheet.getRange(DATA_START_ROW, 1, lastRow - (DATA_START_ROW - 1), 1);
        const idValues = idRange.getValues(); 

        idValues.forEach((row, index) => {
          if (stats.duplicateIds.includes(row[0])) {
            active_sheet.getRange(index + DATA_START_ROW, 1, 1, lastCol).setBackground("#f4cccc");
          }
        });
      }
    }

    // This forces the script to "paint" the spreadsheet before showing the alert
    SpreadsheetApp.flush();

    switch (code) {
      case 201:
      case 200:
        SpreadsheetApp.getUi().alert(
          `✅ Processing Complete\n\n` +
          `• Success: ${stats.okCount}\n` +
          `• Duplicates Found: ${stats.duplicateCount} (red background)`
        );
        break;
      case 403:
        SpreadsheetApp.getUi().alert("❌ Forbidden: Token access required");
        break;
      case 500:
        SpreadsheetApp.getUi().alert("❌ 🖥️ Server related error");
        break;
      default:
        SpreadsheetApp.getUi().alert(`Response Code: ${code}. Check highlights.`);
    }

  } catch (e) {
    Logger.log("Error: " + e.toString());
    SpreadsheetApp.getUi().alert("❌ Error: " + e.message);
  }
}
