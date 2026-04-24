## Test Case 1: Create New Company

**Preconditions:**
User is logged in

**Steps:**
1. Navigate to "Company" tab
2. Click "+" button

**Expected Result:**
New Company creation form is displayed

**Postconditions:**
No company is created until the form is submitted


## Test Case 2: Cancel Company Creation

**Preconditions:**
User is on New Company form

**Steps:**
1. Click "Cancel"

**Expected Result:**
Form is closed and user is redirected to Company list

**Postconditions:**
No new company is created


## Test Case 3: Validate Required Fields

**Preconditions:**
User is on New Company form

**Steps:**
1. Leave required fields empty
2. Click "Save"

**Expected Result:**
System displays validation message:
"Company name is required."
Form is not submitted

**Postconditions:**
No company is created


## Test Case 4: Add New Department

**Preconditions:**
User is logged in and has access to Company module

**Steps:**
1. Navigate to "Company" tab
2. Click "+" to create new Company
3. Click "+" to add Department
4. Fill required fields
5. Click "Save"

**Expected Result:**
Department is successfully created and appears in the list

**Postconditions:**
New department is associated with the company


## Test Case 5: Send Email with Recipients

**Preconditions:**
User is in Job Position tab

**Steps:**
1. Select at least one recipient
2. Click "Send"

**Expected Result:**
Email form is opened with selected recipients populated

**Postconditions:**
Email can be composed and sent


## Test Case 6: Prevent Sending Email Without Recipients

**Preconditions:**
User is in Job Position tab

**Steps:**
1. Deselect all recipients
2. Click "Send"

**Expected Result:**
System displays validation message:
"At least one recipient must be selected."
Send action is blocked

**Postconditions:**
Email form is not opened



## Test Case 7: View Company Details

**Preconditions:**
User is logged in

**Steps:**
1. Navigate to "Company" tab
2. Select a company from the list

**Expected Result:**
Company details are displayed correctly in the right panel

**Postconditions:**
User can interact with company data



## Test Case 8: Check Department Count Consistency

**Preconditions:**
User is in Company module

**Steps:**
1. Select a company
2. Observe department count in left panel
3. Compare with departments displayed in right panel

**Expected Result:**
Department count matches in both panels

**Postconditions:**
Displayed data is consistent across the system
