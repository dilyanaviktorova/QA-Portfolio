## Test Case 1: Create New Company

**Preconditions:**
User is logged in

**Steps:**
1. Navigate to "Company" tab
2. Click "+" button

**Expected Result:**
New Company form is displayed


## Test Case 2: Cancel Company Creation

**Preconditions:**
User is on New Company form

**Steps:**
1. Click "Cancel"

**Expected Result:**
Form is closed without saving



## Test Case 3: Validate Required Fields

**Preconditions:**
User is on New Company form

**Steps:**
1. Leave required fields empty
2. Click "Save"

**Expected Result:**
System displays validation message:
"Company name is required."
Form is not submitted.


## Test Case 4: Add New Department

**Preconditions:**
User is in Company module

**Steps:**
1. Open New Company form
2. Click "+" to add Department
3. Fill required fields
4. Click "Save"

**Expected Result:**
Department is successfully created


## Test Case 5: Send Email with Recipients

**Preconditions:**
User is in Job Position tab

**Steps:**
1. Select at least one recipient
2. Click "Send"

**Expected Result:**
Email form opens with selected recipients



## Test Case 6: Prevent Sending Email Without Recipients

**Preconditions:**
User is in Job Position tab

**Steps:**
1. Deselect all recipients
2. Click "Send"

**Expected Result:**
System displays validation message:
"At least one recipient must be selected."
Email is not sent.


## Test Case 7: View Company Details

**Preconditions:**
User is logged in

**Steps:**
1. Navigate to "Company" tab
2. Select a company from the list

**Expected Result:**
Company details are displayed correctly



## Test Case 8: Check Department Count

**Preconditions:**
User is in Company module

**Steps:**
1. Select a company
2. Compare department count in both panels

**Expected Result:**
Department count matches in both views
