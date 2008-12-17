module SupportHelper
  def reply_to(ticket, answer)
    subject = "Re:" + ticket.subject
    message = ""
    #history = thread(ticket.root, answer.id)
    message = prepare_text(thread(ticket, answer.id))
    [subject, message]
  end
  
  def history(ticket)
    return "" unless ticket&&ticket.parent
    message = ""
    history = thread(ticket.parent)
    message = prepare_text(history)
    message    
  end
  
  def  thread(ticket, answer_id=nil)
    message=%Q(\n-----------Ticket ID##{ticket.id}-----------\n)
    message+= ticket.email+"(#{ticket.created_at.strftime("%d/%m/%Y %H:%M")}):\n"
    message+= "Ticket ID##{ticket.id}: #{ticket.subject}\n"
    message+=ticket.message
    answers = ticket.answers.find(:all, :order=>"created_at")
    message+=%Q(\n) if answers.size>0
    answers.each do |answer|
      message+=%Q(\n)
      message+="PDB Admin (#{answer.created_at.strftime("%d/%m/%Y %H:%M")}):\n"
      message+=answer.message + "\n"
      message+ %Q(\n)
      break if answer.id == answer_id
    end
    message+=%Q(\n) if answers.size>1
   
    unless answers.map(&:id).include?(answer_id)
    ticket.children.find(:all, :order=>"created_at").each do |child|
      message+=thread(child, answer_id)
    end
    end
    message +  %Q(\n)
  end
  
  def prepare_text(text)
    message = ""
    text.each_line do |line|
      message+=">" + line
    end
    message
  end
end
