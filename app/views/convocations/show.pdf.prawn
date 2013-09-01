@convocation.convocation_firemen.each do |convocation_fireman|
  # because partial need an instance variable
  @convocation_fireman = convocation_fireman
  partial!("convocation_firemen/convocation")
  pdf.start_new_page unless (pdf.page_count == @convocation.firemen.length)
end