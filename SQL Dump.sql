CREATE TABLE GARAGES (
	Garage_ID INT NOT NULL UNIQUE,
	Garage_Name VARCHAR(20) NOT NULL,
	Street VARCHAR(25) NOT NULL,
	Suburb VARCHAR(20) NOT NULL,
	City VARCHAR(20) NOT NULL,
	Type_of_Services CHAR(15) NULL,
	Payment_Method CHAR(20) NULL,
	PRIMARY KEY (Garage_ID)
);

CREATE TABLE CARS (
	Registration_Number VARCHAR(10) NOT NULL UNIQUE,
	Make CHAR(15) NOT NULL,
	Model CHAR(15) NOT NULL,
	Year_of_Production INT NOT NULL,
	Engine_Size CHAR(10) NOT NULL,
	Fuel_Type CHAR(10) NOT NULL,
	Number_of_Passengers INT NULL,
	Purchase_Price DECIMAL(8,2) NULL,
	Purchase_Date DATETIME NULL,
	Daily_Rent_Price DECIMAL(6,2) NULL,
	Insurance_Details VARCHAR(50) NULL,
	Garage_ID INT NULL,
	PRIMARY KEY(Registration_Number),
	FOREIGN KEY(Garage_ID) REFERENCES GARAGES(Garage_ID) ON DELETE SET NULL, /* Will set the Garage ID as NULL if the Garage is Deleted from the Garage Table */
	CHECK (DATEADD(year,1,Purchase_Date) > getDate()) /* Checks that the purchase date is within the last year */
);

CREATE TABLE INSURANCE_DETAILS (
	Registration_Number VARCHAR(10) NOT NULL,
	Insurance_Company VARCHAR(15) NOT NULL,
	Insurance_Type CHAR(15) NOT NULL,
	Insurance_Excess DECIMAL(7,2) NOT NULL,
	Insurance_Premium DECIMAL(7,2) NOT NULL,
	Payment_Method CHAR(10) NOT NULL,
	Insurance_Renewal_Date DATETIME NOT NULL,
	Additional_Insurance_Details VARCHAR(300) NULL,
	PRIMARY KEY(Registration_Number),
	FOREIGN KEY(Registration_Number) REFERENCES CARS(Registration_Number) ON DELETE CASCADE /* If the Car is Deleted then the Insurance Details for that car will be deleted - ensuring that Referential Integreity is intact so that the data is deleted for the car and not left behind */
	);

CREATE TABLE OUTGOING_EXPENDITURES (
	Expense_ID INT UNIQUE NOT NULL,
	Registration_Number VARCHAR(10) NULL,
	Details_of_Expense VARCHAR(30) NOT NULL,
	Cost DECIMAL(9,2) NOT NULL,
	PRIMARY KEY (Expense_ID),
	FOREIGN KEY (Registration_Number) REFERENCES CARS(Registration_Number) ON DELETE SET NULL /* Sets the Registration Number as NULL - important so that the Expenses are still able to be kept for Auditing Requirements etc */
);

CREATE TABLE INCOMING_REVENUES (
	Income_ID INT UNIQUE NOT NULL,
	Registration_Number VARCHAR(10) NULL,
	Details_of_Income VARCHAR(30) NOT NULL,
	Income DECIMAL(9,2) NOT NULL,
	PRIMARY KEY (Income_ID),
	FOREIGN KEY (Registration_Number) REFERENCES CARS(Registration_Number) ON DELETE SET NULL  /* Sets the Registration Number as NULL - important so that the Incomes are still able to be kept for Auditing Requirements etc */
);

CREATE TABLE CUSTOMERS (
	Customer_ID INT UNIQUE NOT NULL,
	First_Name VARCHAR(15) NOT NULL,
	Last_Name VARCHAR(15) NOT NULL,
	Street VARCHAR(25) NOT NULL,
	Suburb  VARCHAR(10) NOT NULL,
	City VARCHAR(15) NOT NULL,
	Country VARCHAR(20) NOT NULL,
	Postcode INT NOT NULL,
	Telephone_No DECIMAL(12,0) NULL,
	Driver_License_No VARCHAR(10) NOT NULL,
	Payment_Method CHAR(20) NULL,
	PRIMARY KEY(Customer_ID)
);

CREATE TABLE CUSTOMERS_CASUAL (
	Customer_ID INT UNIQUE NOT NULL,
	Deposit DECIMAL(7,2) NOT NULL,
	Estimated_Time_of_Arrival DATETIME NOT NULL,
	PRIMARY KEY (Customer_ID),
	FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS(Customer_ID) ON DELETE CASCADE /* If the Customers details are deleted from the CUSTOMERS table it will delete them in the Customers_Casual Table - Important for Referential Integreity to enusre it is intact so that the data is deleted for the Customer and not left behind */
);

CREATE TABLE BOOKINGS(
	Booking_ID INT UNIQUE NOT NULL,
	Customer_ID INT NOT NULL,
	Registration_Number VARCHAR(10) NULL,
	Start_Date DATETIME NOT NULL,
	End_Date DATETIME NOT NULL,
	Payment_Method CHAR(20) NULL,
	PRIMARY KEY (Booking_ID),
	FOREIGN KEY (Registration_Number) REFERENCES Cars(Registration_Number) ON DELETE SET NULL, /* Sets the Registration Number as NULL if the Car is deleted from the CARS table - don't want to delete the Booking entry if the car gets sold etc */
	FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS(Customer_ID) ON DELETE CASCADE /* Delete the Booking if the Customer is deleted from the CUSTOMERS Table */
);

CREATE TABLE CUSTOMERS_VIP (
	Customer_ID INT UNIQUE NOT NULL,
	Booking_ID INT NULL,
	Registration_Number VARCHAR(10) NULL,
	PRIMARY KEY (Customer_ID),
	FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS(Customer_ID) ON DELETE CASCADE, /* If the Customers details are deleted from the CUSTOMERS_VIP table it will delete them in the Customers_Casual Table - Important for Referential Integreity to enusre it is intact so that the data is deleted for the Customer and not left behind */
	FOREIGN KEY (Booking_ID) REFERENCES BOOKINGS(Booking_ID),
	FOREIGN KEY (Registration_Number) REFERENCES CARS(Registration_Number) ON DELETE SET NULL /* Set the Registration Number as Null if the Car is deleted from the database */
);