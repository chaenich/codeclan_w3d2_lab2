DROP TABLE IF EXISTS properties;

CREATE TABLE property_table(
     id SERIAL4 PRIMARY KEY,
     address VARCHAR(255),
     value INT4,
     bedrooms INT2,
     year_built INT2
);
