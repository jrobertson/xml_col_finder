# Introducing the xml_col_finder gem

    require 'xml_col_finder'

    s = "<a class='tapItem fs-unmask result job_6695df76e0d6f509 sponsoredJob resultWithShelf sponTapItem desktop' data-ci='381562938' data-empn='620689036589278' data-hide-spinner='true' data-hiring-event='false' data-jk='6695df76e0d6f509' data-mobtk='1fq1nms86tvhn800' href='/pagead/clk?mo=r&amp;ad=-6NYlbfkN0BRdh2c3bHuI6K-F4Sp0xI1zqNe2Eqvwqtvecrs6HUC9LV85PRR10P8FwHiO2rATCM_0gzpG8l5vkTs_2SHXB0fkV6ctMg7g1wJFo5tygZveyBYJpF0D-Azt4UdNJHE8L2aJcs8aUL9oUMB8Er2eWlo2Tk-Vmcter5eN1OjQbPtvXJBPD678zXMcvO7FlFdPH4H3R2QYVcScvbAWEGNJkR8S0CuO7k5RofW-hsqsIV-wQ453dfQSP7p6NsaNTBMTZE2e5mUANAfFXOo591mboVD4MwhjI43FRSgqP_mJeEX7Iw7KTKcnrdx9BXw6TUAzY9R9NYXW1WZ9glYTYr4kFUWiLD6HrMsFNZD7j_4ncWO2Y8iYIkMRUGrE4-MDX--h3-K5jG0yEZTI69xVrkXSc45qEBzFvcZ9o8_WzM_sZD4vzgDCDhLEWqBnUiWOat6wS4jV50ZBcU0AS0tOJOhr-1IHNPpFQhM1wrHR9TjgJ4Xkb-DjO7lpXvZdOHYysPnwIQ-F37Ad4FXlTXT48d-zjVR_csq1ak5O7ajS6nJqPcam7z5FWhf0u0cKUUViRplxClMUM98lFnwGw==&amp;p=0&amp;fvj=0&amp;vjs=3' id='sj_6695df76e0d6f509' rel='nofollow' target='_blank'><div class='slider_container'><div class='slider_list'><div class='slider_item'><div class='job_seen_beacon'><div class='fe_logo'><img alt='NatWest Group logo' class='feLogoImg desktop' src='https://d2q79iu7y748jz.cloudfront.net/s/_squarelogo/256x256/c11e385a5fe13a13dadba15df0e8c831'/></div><table cellpadding='0' cellspacing='0' class='jobCard_mainContent' role='presentation'><tbody><tr><td class='resultContent'><div class='heading4 color-text-primary singleLineTitle tapItem-gutter'><h2 class='jobTitle jobTitle-color-purple'><span title='Software Engineering - Graduate Programme'>Software Engineering - Graduate Programme</span></h2></div><div class='heading6 company_location tapItem-gutter companyInfo'><span class='companyName'><a class='turnstileLink companyOverviewLink' data-tn-element='companyName' href='/cmp/Natwest-Group' rel='noopener' target='_blank'>NatWest Group</a></span><span class='ratingsDisplay withRatingLink'><a class='ratingLink' data-tn-variant='cmplinktst2' href='/cmp/Natwest-Group/reviews' rel='noopener' target='_blank' title='NatWest Group reviews'><span aria-label='3.3 of stars rating' class='ratingNumber' role='img'><span aria-hidden='true'>3.3</span><svg aria-hidden='true' class='starIcon' fill='none' height='12' role='presentation' viewbox='0 0 16 16' width='12' xmlns='http://www.w3.org/2000/svg'><path d='M8 12.8709L12.4542 15.5593C12.7807 15.7563 13.1835 15.4636 13.0968 15.0922L11.9148 10.0254L15.8505 6.61581C16.1388 6.36608 15.9847 5.89257 15.6047 5.86033L10.423 5.42072L8.39696 0.640342C8.24839 0.289808 7.7516 0.289808 7.60303 0.640341L5.57696 5.42072L0.395297 5.86033C0.015274 5.89257 -0.13882 6.36608 0.149443 6.61581L4.0852 10.0254L2.90318 15.0922C2.81653 15.4636 3.21932 15.7563 3.54584 15.5593L8 12.8709Z' fill='#767676'/></svg></span></a></span><div class='companyLocation'>Edinburgh</div></div><div class='heading6 tapItem-gutter metadataContainer'><div class='metadata salary-snippet-container'><div aria-label='£31,850 a year' class='salary-snippet'><span>£31,850 a year</span></div></div></div><div class='heading6 error-text tapItem-gutter'/></td></tr></tbody></table><table class='jobCardShelfContainer' role='presentation'><tbody><tr class='jobCardShelf'/><tr class='underShelfFooter'><td><div class='heading6 tapItem-gutter result-footer'><div class='job-snippet'><ul style='list-style-type:circle;margin-top: 0px;margin-bottom: 0px;padding-left:20px;'> \n <li style='margin-bottom:0px;'>From home working to job sharing, visit the remote and flexible working page on our website to find out more.</li>\n <li>And on top of your salary, you’ll also have access…</li>\n</ul></div><span class='date'><span class='visually-hidden'>Posted</span>30+ days ago</span></div></td></tr></tbody></table><div aria-live='polite'/></div></div><div class='slider_sub_item'/></div></div><div class='kebabMenu'><button aria-expanded='false' aria-haspopup='true' aria-label='Job actions' class='kebabMenu-button'><svg aria-hidden='true' fill='none' height='24' role='presentation' viewbox='0 0 24 24' width='24' xmlns='http://www.w3.org/2000/svg'><path d='M12 7C13.1 7 14 6.1 14 5C14 3.9 13.1 3 12 3C10.9 3 10 3.9 10 5C10 6.1 10.9 7 12 7ZM12 10C10.9 10 10 10.9 10 12C10 13.1 10.9 14 12 14C13.1 14 14 13.1 14 12C14 10.9 13.1 10 12 10ZM12 17C10.9 17 10 17.9 10 19C10 20.1 10.9 21 12 21C13.1 21 14 20.1 14 19C14 17.9 13.1 17 12 17Z' fill='#2d2d2d'/></svg></button></div></a>" 
    a = XMLColFinder.new(s).to_a

    pp a
    <pre>
    ["a[@class='tapItem']/div[@class='slider_container']/div[@class='slider_list']/div[@class='slider_item']/div[@class='job_seen_beacon']",    
     [[["/table[@class='jobCard_mainContent']/tbody/tr/td[@class='resultContent']",
        [[["/div[@class='heading4']/h2[@class='jobTitle']/span", "Software Engineering - Graduate Programme"]],
         ["/div[@class='heading6']",
          [["/span[@class='companyName']/a[@class='turnstileLink']", "NatWest Group"],
           ["/span[@class='ratingsDisplay']/a[@class='ratingLink']/span[@class='ratingNumber']/span", "3.3"],
           ["/div[@class='companyLocation']", "Edinburgh"],
           ["/div[@class='metadata']/div[@class='salary-snippet']/span", "£31,850 a year"]]]]]],
      ["/table[@class='jobCardShelfContainer']/tbody/tr[@class='underShelfFooter']/td/div[@class='heading6']",
       [["/div[@class='job-snippet']/ul",
         [nil,
          ["/li",
           ["From home working to job sharing, visit the remote and flexible working page on our website to find out more.",
            "And on top of your salary, you’ll also have access…"]]]],
        [[["/span[@class='date']/span[@class='visually-hidden']", "Posted"]]]]]]] 
    </pre>

## Resources

* xml_col_finder https://rubygems.org/gems/xml_col_finder

xml_col_finder xmlcolfinder col cols columns recordset scraper xml
