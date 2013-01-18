require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "Product Attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "Product price must be positive" do
    @product = _new_product(:price => '', :image_url => 'test.gif')
    
    assert @product.invalid?
    
    _test_invalid_price(-1)
    _test_invalid_price(-0)
    _test_invalid_price(0.001)
     
     
    @product.price = 1
    assert @product.valid?
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png Fred.JPG FRED.Jpg
             http://a.b.c/adfga/fred.gif}
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert _new_product(:image_url => name).valid? , 
             "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert _new_product(:image_url => name).invalid? ,
             "#{name} shouldn't be valid"
    end
  end  
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title)
    
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
  
  def _test_invalid_price(price)
    @product.price = price
    assert @product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                 @product.errors[:price]
  end
  
  def _new_product(params={})
    params = {
      :title => 'Test',
      :description => 'Test',
      :price => '1', 
      :image_url => 'test.gif'
    }.merge(params)
    
    Product.new(title: params[:title],
                description: params[:description],
                price: params[:price],
                image_url: params[:image_url])
  end

end
