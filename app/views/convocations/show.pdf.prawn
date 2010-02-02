@convocation.convocation_firemen.each do |convocation_fireman|
  render(:partial => "convocation_firemen/convocation_fireman", :locals => {:convocation_fireman => convocation_fireman,
                                                                :convocation => @convocation,
                                                                :_pdf => pdf})
  pdf.start_new_page unless (pdf.page_count == @convocation.firemen.length)
end