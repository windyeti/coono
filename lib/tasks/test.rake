namespace :p do

  # require 'capybara/dsl'
  # include Capybara::DSL

  task p: :environment do
    doc = get_doc "http://www.colors.commutercreative.com/grid/"
    result = {}
    doc.css('#portfolio li').each_with_index do |li, index|
      # index = index % 2 == 0 ? 148 - index : index
      color = li['style'].gsub("background:", "").gsub(" ;", "").strip
      result[index.to_s] = color
    end
  p result
  end

  def get_doc(url)
    category_url = URI.escape(url)
    Nokogiri::HTML('
<div id="post-wrap">
						<ul id="portfolio">





							<li style=" background: Aqua ;" class="
			              aqua light
							">
			        <a href=" http://www.colors.commutercreative.com/aqua/ ">Aqua</a></li>









							<li style=" background: Black ;" class="
			              dark gray
							">
			        <a href=" http://www.colors.commutercreative.com/black/ ">Black</a></li>

							<li style=" background: BlanchedAlmond ;" class="
			              brown light
							">
			        <a href=" http://www.colors.commutercreative.com/blanchedalmond/ ">BlanchedAlmond</a></li>

							<li style=" background: Blue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/blue/ ">Blue</a></li>

							<li style=" background: BlueViolet ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/blueviolet/ ">BlueViolet</a></li>

							<li style=" background: Brown ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/brown/ ">Brown</a></li>

							<li style=" background: BurlyWood ;" class="
			              brown light
							">
			        <a href=" http://www.colors.commutercreative.com/burlywood/ ">BurlyWood</a></li>

							<li style=" background: CadetBlue ;" class="
			              cyan dark
							">
			        <a href=" http://www.colors.commutercreative.com/cadetblue/ ">CadetBlue</a></li>

							<li style=" background: Chartreuse ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/chartreuse/ ">Chartreuse</a></li>

							<li style=" background: Chocolate ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/chocolate/ ">Chocolate</a></li>

							<li style=" background: Coral ;" class="
			              light orange
							">
			        <a href=" http://www.colors.commutercreative.com/coral/ ">Coral</a></li>

							<li style=" background: CornflowerBlue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/cornflowerblue/ ">CornflowerBlue</a></li>



							<li style=" background: Crimson ;" class="
			              dark red
							">
			        <a href=" http://www.colors.commutercreative.com/crimson/ ">Crimson</a></li>

							<li style=" background: Cyan ;" class="
			              cyan light
							">
			        <a href=" http://www.colors.commutercreative.com/cyan/ ">Cyan</a></li>

							<li style=" background: DarkBlue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/darkblue/ ">DarkBlue</a></li>

							<li style=" background: DarkCyan ;" class="
			              cyan dark
							">
			        <a href=" http://www.colors.commutercreative.com/darkcyan/ ">DarkCyan</a></li>

							<li style=" background: DarkGoldenRod ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/darkgoldenrod/ ">DarkGoldenRod</a></li>



							<li style=" background: DarkGreen ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/darkgreen/ ">DarkGreen</a></li>

							<li style=" background: DarkGrey ;" class="
			              dark gray
							">
			        <a href=" http://www.colors.commutercreative.com/dark-grey/ ">DarkGrey</a></li>

							<li style=" background: DarkKhaki ;" class="
			              dark yellow
							">
			        <a href=" http://www.colors.commutercreative.com/darkkhaki/ ">DarkKhaki</a></li>

							<li style=" background: DarkMagenta ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/darkmagenta/ ">DarkMagenta</a></li>

							<li style=" background: DarkOliveGreen ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/darkolivegreen/ ">DarkOliveGreen</a></li>

							<li style=" background: DarkOrange ;" class="
			              dark orange
							">
			        <a href=" http://www.colors.commutercreative.com/darkorange/ ">DarkOrange</a></li>



							<li style=" background: DarkRed ;" class="
			              dark red
							">
			        <a href=" http://www.colors.commutercreative.com/darkred/ ">DarkRed</a></li>

							<li style=" background: DarkSalmon ;" class="
			              dark red
							">
			        <a href=" http://www.colors.commutercreative.com/darksalmon/ ">DarkSalmon</a></li>

							<li style=" background: DarkSeaGreen ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/darkseagreen/ ">DarkSeaGreen</a></li>

							<li style=" background: DarkSlateBlue ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/darkslateblue/ ">DarkSlateBlue</a></li>



							<li style=" background: DarkSlateGrey ;" class="
			              dark gray
							">
			        <a href=" http://www.colors.commutercreative.com/darkslategrey/ ">DarkSlateGrey</a></li>

							<li style=" background: DarkTurquoise ;" class="
			              aqua dark
							">
			        <a href=" http://www.colors.commutercreative.com/darkturquoise/ ">DarkTurquoise</a></li>

							<li style=" background: DarkViolet ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/darkviolet/ ">DarkViolet</a></li>

							<li style=" background: DeepPink ;" class="
			              dark pink
							">
			        <a href=" http://www.colors.commutercreative.com/deeppink/ ">DeepPink</a></li>

							<li style=" background: DeepSkyBlue ;" class="
			              blue light
							">
			        <a href=" http://www.colors.commutercreative.com/deepskyblue/ ">DeepSkyBlue</a></li>



							<li style=" background: DimGrey ;" class="
			              dark gray
							">
			        <a href=" http://www.colors.commutercreative.com/dimgrey/ ">DimGrey</a></li>

							<li style=" background: DodgerBlue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/dodgerblue/ ">DodgerBlue</a></li>

							<li style=" background: FireBrick ;" class="
			              dark red
							">
			        <a href=" http://www.colors.commutercreative.com/firebrick/ ">FireBrick</a></li>





							<li style=" background: Fuchsia ;" class="
			              light purple
							">
			        <a href=" http://www.colors.commutercreative.com/fuchsia/ ">Fuchsia</a></li>





							<li style=" background: Gold ;" class="
			              light orange
							">
			        <a href=" http://www.colors.commutercreative.com/gold/ ">Gold</a></li>

							<li style=" background: Goldenrod ;" class="
			              brown light
							">
			        <a href=" http://www.colors.commutercreative.com/goldenrod/ ">Goldenrod</a></li>

							<li style=" background: Gray ;" class="
			              dark
							">
			        <a href=" http://www.colors.commutercreative.com/gray/ ">Gray</a></li>

							<li style=" background: Green ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/green/ ">Green</a></li>

							<li style=" background: GreenYellow ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/greenyellow/ ">GreenYellow</a></li>





							<li style=" background: HotPink ;" class="
			              light pink
							">
			        <a href=" http://www.colors.commutercreative.com/hotpink/ ">HotPink</a></li>

							<li style=" background: IndianRed ;" class="
			              dark red
							">
			        <a href=" http://www.colors.commutercreative.com/indianred/ ">IndianRed</a></li>

							<li style=" background: Indigo ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/indigo/ ">Indigo</a></li>



							<li style=" background: Khaki ;" class="
			              light yellow
							">
			        <a href=" http://www.colors.commutercreative.com/khaki/ ">Khaki</a></li>









							<li style=" background: LightBlue ;" class="
			              blue light
							">
			        <a href=" http://www.colors.commutercreative.com/lightblue/ ">LightBlue</a></li>

							<li style=" background: LightCoral ;" class="
			              light red
							">
			        <a href=" http://www.colors.commutercreative.com/lightcoral/ ">LightCoral</a></li>







							<li style=" background: LightGreen ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/lightgreen/ ">LightGreen</a></li>



							<li style=" background: LightPink ;" class="
			              light pink
							">
			        <a href=" http://www.colors.commutercreative.com/lightpink/ ">LightPink</a></li>

							<li style=" background: LightSalmon ;" class="
			              red uncategorized
							">
			        <a href=" http://www.colors.commutercreative.com/lightsalmon/ ">LightSalmon</a></li>

							<li style=" background: LightSeaGreen ;" class="
			              aqua light
							">
			        <a href=" http://www.colors.commutercreative.com/lightseagreen/ ">LightSeaGreen</a></li>

							<li style=" background: LightSkyBlue ;" class="
			              blue light
							">
			        <a href=" http://www.colors.commutercreative.com/lightskyblue/ ">LightSkyBlue</a></li>



							<li style=" background: LightSlateGrey ;" class="
			              gray light
							">
			        <a href=" http://www.colors.commutercreative.com/lightslategrey/ ">LightSlateGrey</a></li>





							<li style=" background: Lime ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/lime/ ">Lime</a></li>

							<li style=" background: LimeGreen ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/limegreen/ ">LimeGreen</a></li>



							<li style=" background: Magenta ;" class="
			              light purple
							">
			        <a href=" http://www.colors.commutercreative.com/magenta/ ">Magenta</a></li>

							<li style=" background: Maroon ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/maroon/ ">Maroon</a></li>

							<li style=" background: MediumAquaMarine ;" class="
			              aqua light
							">
			        <a href=" http://www.colors.commutercreative.com/mediumaquamarine/ ">MediumAquaMarine</a></li>

							<li style=" background: MediumBlue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/mediumblue/ ">MediumBlue</a></li>

							<li style=" background: MediumOrchid ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/mediumorchid/ ">MediumOrchid</a></li>

							<li style=" background: MediumPurple ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/mediumpurple/ ">MediumPurple</a></li>

							<li style=" background: MediumSeaGreen ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/mediumseagreen/ ">MediumSeaGreen</a></li>

							<li style=" background: MediumSlateBlue ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/mediumslateblue/ ">MediumSlateBlue</a></li>

							<li style=" background: MediumSpringGreen ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/mediumspringgreen/ ">MediumSpringGreen</a></li>

							<li style=" background: MediumTurquoise ;" class="
			              aqua dark
							">
			        <a href=" http://www.colors.commutercreative.com/mediumturquoise/ ">MediumTurquoise</a></li>

							<li style=" background: MediumVioletRed ;" class="
			              dark pink
							">
			        <a href=" http://www.colors.commutercreative.com/mediumvioletred/ ">MediumVioletRed</a></li>











							<li style=" background: Navy ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/navy/ ">Navy</a></li>



							<li style=" background: Olive ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/olive/ ">Olive</a></li>

							<li style=" background: OliveDrab ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/olivedrab/ ">OliveDrab</a></li>

							<li style=" background: Orange ;" class="
			              light orange
							">
			        <a href=" http://www.colors.commutercreative.com/orange/ ">Orange</a></li>

							<li style=" background: OrangeRed ;" class="
			              dark orange
							">
			        <a href=" http://www.colors.commutercreative.com/orangered/ ">OrangeRed</a></li>

							<li style=" background: Orchid ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/orchid/ ">Orchid</a></li>



							<li style=" background: PaleGreen ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/palegreen/ ">PaleGreen</a></li>

							<li style=" background: PaleTurquoise ;" class="
			              aqua light
							">
			        <a href=" http://www.colors.commutercreative.com/paleturquoise/ ">PaleTurquoise</a></li>

							<li style=" background: PaleVioletRed ;" class="
			              dark pink
							">
			        <a href=" http://www.colors.commutercreative.com/palevioletred/ ">PaleVioletRed</a></li>





							<li style=" background: Peru ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/peru/ ">Peru</a></li>

							<li style=" background: Pink ;" class="
			              light pink
							">
			        <a href=" http://www.colors.commutercreative.com/pink/ ">Pink</a></li>

							<li style=" background: Plum ;" class="
			              light purple
							">
			        <a href=" http://www.colors.commutercreative.com/plum/ ">Plum</a></li>



							<li style=" background: Purple ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/purple/ ">Purple</a></li>

							<li style=" background: RebeccaPurple ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/rebeccapurple/ ">RebeccaPurple</a></li>

							<li style=" background: Red ;" class="
			              dark red
							">
			        <a href=" http://www.colors.commutercreative.com/red/ ">Red</a></li>

							<li style=" background: RosyBrown ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/rosybrown/ ">RosyBrown</a></li>

							<li style=" background: RoyalBlue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/royalblue/ ">RoyalBlue</a></li>

							<li style=" background: SaddleBrown ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/saddlebrown/ ">SaddleBrown</a></li>

							<li style=" background: Salmon ;" class="
			              light red
							">
			        <a href=" http://www.colors.commutercreative.com/salmon/ ">Salmon</a></li>

							<li style=" background: SandyBrown ;" class="
			              brown light
							">
			        <a href=" http://www.colors.commutercreative.com/sandybrown/ ">SandyBrown</a></li>

							<li style=" background: SeaGreen ;" class="
			              dark green
							">
			        <a href=" http://www.colors.commutercreative.com/seagreen/ ">SeaGreen</a></li>



							<li style=" background: Sienna ;" class="
			              brown dark
							">
			        <a href=" http://www.colors.commutercreative.com/sienna/ ">Sienna</a></li>



							<li style=" background: SkyBlue ;" class="
			              blue light
							">
			        <a href=" http://www.colors.commutercreative.com/skyblue/ ">SkyBlue</a></li>

							<li style=" background: SlateBlue ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/slateblue/ ">SlateBlue</a></li>



							<li style=" background: SlateGrey ;" class="
			              dark gray
							">
			        <a href=" http://www.colors.commutercreative.com/slategrey/ ">SlateGrey</a></li>



							<li style=" background: SpringGreen ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/springgreen/ ">SpringGreen</a></li>

							<li style=" background: SteelBlue ;" class="
			              blue dark
							">
			        <a href=" http://www.colors.commutercreative.com/steelblue/ ">SteelBlue</a></li>

							<li style=" background: Tan ;" class="
			              brown light
							">
			        <a href=" http://www.colors.commutercreative.com/tan/ ">Tan</a></li>

							<li style=" background: Teal ;" class="
			              cyan dark
							">
			        <a href=" http://www.colors.commutercreative.com/teal/ ">Teal</a></li>

							<li style=" background: Thistle ;" class="
			              light purple
							">
			        <a href=" http://www.colors.commutercreative.com/thistle/ ">Thistle</a></li>

							<li style=" background: Tomato ;" class="
			              orange
							">
			        <a href=" http://www.colors.commutercreative.com/tomato/ ">Tomato</a></li>

							<li style=" background: Turquoise ;" class="
			              aqua light
							">
			        <a href=" http://www.colors.commutercreative.com/turquoise/ ">Turquoise</a></li>

							<li style=" background: Violet ;" class="
			              dark purple
							">
			        <a href=" http://www.colors.commutercreative.com/violet/ ">Violet</a></li>

							<li style=" background: Wheat ;" class="
			              brown light
							">
			        <a href=" http://www.colors.commutercreative.com/wheat/ ">Wheat</a></li>





							<li style=" background: Yellow ;" class="
			              light yellow
							">
			        <a href=" http://www.colors.commutercreative.com/yellow/ ">Yellow</a></li>

							<li style=" background: YellowGreen ;" class="
			              green light
							">
			        <a href=" http://www.colors.commutercreative.com/yellowgreen/ ">YellowGreen</a></li>
																											</ul>
					</div>
')
  end
  # def get_doc(url)
  #   category_url = URI.escape(url)
  #   Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 20, :method => :get, :verify_ssl => false))
  # end

    # doc.at('#combo-price .price span').text.strip
    # p title = doc.at('.hdr-block.def h1').text.strip
    #
    #
    #
    #
    # p p1 = if doc.at('#paramList')
    #        doc_text_block = doc.at('#paramList')
    #        result = []
    #        doc_dts = doc_text_block.css('dt')
    #        doc_dds = doc_text_block.css('dd')
    #        doc_dts.each_with_index { |doc_dt, index| result << "#{doc_dt.text.strip}: #{doc_dds[index].text.strip}"}
    #        result.join(' --- ')
    #      else
    #        nil
    #      end
    #
    # p pict = get_pict(doc)
    #
    # p desc = doc.at('#fld-desc').inner_html.strip rescue nil


    # if doc.at('.hdr-block.def h1').text.strip.include?("Каминокомплект")
    #   p price = doc.at('#combo-price .price span').text.strip rescue nil
    # else
    #   p price = doc.at('meta[itemprop="price"]')['content'] rescue nil
    # end




  # def get_pict(doc)
  #   result = []
  #   doc_picts = doc.css('.sku__gallery a')
  #   if doc_picts.present?
  #     result = doc_picts.map do |doc_pict|
  #       doc_pict['href']
  #     end
  #   else
  #     nil
  #   end
  #   result.join(' ')
  # end


  # task t: :environment do

  # end

end
