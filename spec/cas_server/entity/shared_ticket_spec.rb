describe "CAS ticket", :shared => true do
  # 3.7.
  it "MUST contain only characters from the set {A-Z, a-z, 0-9, and the 
  hyphen character ?-'}" do
    @ticket.value.should match(/^[a-zA-Z0-9\-\?]+$/)
  end
  
  # 3.6.1. & 3.1.1 & 3.5.1
  it "MUST contain adequate secure random data so that a ticket is not guessable in a reasonable period of time." do
    @ticket.value.length.should > 200
    @ticket2 = @ticket.class.generate_for(*@valid_args)

    #dummy but kinda hard to test
    common_char = 0
    @ticket.value.each_with_index do |char,i|
      common_char+=1 if @ticket2[i] == char
    end
    common_char.should < 10
  end
end