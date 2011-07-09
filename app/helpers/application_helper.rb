module ApplicationHelper
  def flash_object_tag(url, width, height, flashvars_hash, bgcolor, show_upgrade_message = true)
    mab = Markaby::Builder.new
    mab.div do
      div.flashcontent!(:style => "width: #{width}; height: #{height}") do
        strong "You need to upgrade your Flash Player and enable Javascript to use this site" if show_upgrade_message
      end

      script(:type => "text/javascript") do
        text %{
		      // <![CDATA[
           var so = new SWFObject('#{url}', 'EmmetFlashApp', '#{width}', '#{height}', '9', '##{bgcolor}');
           so.addVariable("xmlURL", "#{flashvars_hash[:xml_url]}");
           so.addVariable("bgcolor", "0x#{bgcolor}");
           so.write("flashcontent");
       		// ]]>
         }
      end
    end
    mab.to_s.html_safe
  end
end
