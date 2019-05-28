require('pry')
require_relative('models/property')


property1 = Property.new(
     {
          'address'=>'2 Test Lane , Test Town',
          'value'=>'10000',
          'bedrooms'=>'3',
          'year_built'=>'1950'
     }
)

property2 = Property.new(
     {
          'address'=>'5 Test Lane , Test Town',
          'value'=>'20000',
          'bedrooms'=>'4',
          'year_built'=>'2010'
     }
)

property1.save()
binding.pry

nil