require('pg')

class Property
     attr_accessor :address, :value, :bedrooms, :year_built
     attr_reader :id

     def initialize(details)
          @address=details['address']
          @value=details['value'].to_i
          @bedrooms=details['bedrooms'].to_i
          @year_built=details['year_built'].to_i
          @id=details['id'].to_i if details['id']
     end

     def update
          database=PG.connect({dbname: 'properties',host: 'localhost'})
          sql="UPDATE property_table
          SET
          (
               address,
               value,
               bedrooms,
               year_built
          ) =
          (
               $1, $2, $3, $4
          )
          WHERE id=$5  RETURNING *"
          values=[@address,@value,@bedrooms,@year_built,@id]
          database.prepare("update",sql)
          result=database.exec_prepared("update",values)
          database.close()
          return result

     end

     def save
          database=PG.connect({ dbname: 'properties',host: 'localhost'})
          sql = "
          INSERT INTO property_table 
          (
               address, value, bedrooms, year_built
          ) VALUES ($1,$2,$3,$4) RETURNING *;
          "
          values=[@address,@value,@bedrooms,@year_built]
          database.prepare("save",sql) # stops sql injection, and can also be used to optimise code
          saved_order=database.exec_prepared("save",values) #save array of hashes
          saved_order_hash=saved_order[0] # remember [0] because you get back an array
          @id=saved_order_hash['id'].to_i  #always remember to convert from string
          database.close()
     end
     
     def delete
          database=PG.connect({dbname: 'properties',host: 'localhost'})
          sql="DELETE FROM property_table WHERE id= $1"
          database.prepare("delete_one",sql)
          values=[@id]
          database.exec_prepared("delete_one",values)
          database.close()
     end

     def Property.find(id)
          database=PG.connect({dbname: 'properties', host: 'localhost'})
          sql ="SELECT * FROM property_table WHERE ID = $1;"    # returns an array of hashes
          database.prepare("all",sql)
          values=[id]
          property_hash=database.exec_prepared("all", values)
          database.close
          return Property.new(property_hash.first())
     end

     def Property.find_by_address(address)
          database=PG.connect({dbname: 'properties', host: 'localhost'})
          sql ="SELECT * FROM property_table WHERE address = $1;"    # returns an array of hashes
          database.prepare("all",sql)
          values=[address]
          property_hash=database.exec_prepared("all", values).first
          database.close
          if property_hash==nil
               return "not found"
          else
               return Property.new(property_hash)
          end
     end

     def Property.all()
          database=PG.connect({dbname: 'properties', host: 'localhost'})
          sql ="SELECT * FROM property_table;"    # returns an array of hashes
          database.prepare("all",sql)
          orders = database.exec_prepared("all")
          database.close
          return orders.map{|order| Property.new(order)}
     end

     def Property.delete_all()
          database=PG.connect({dbname: 'properties', host: 'localhost'})
          sql="DELETE FROM property_table"
          database.prepare("delete_all",sql)
          database.exec_prepared("delete_all")
          database.close()
     end



end