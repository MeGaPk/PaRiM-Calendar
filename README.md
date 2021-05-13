### Start project 
- Open in xcode
- Wait for finishing installation of SPM
- Click on PaRiM.xcproject -> Select target "PaRiM" -> Click "Signing & Capabilities" -> Resolve Signing problem if you have.  
- Run!

### Possible performance issues when:
- Updating tableview
- Put `duration` more 100 days in `CalendarDateCalculation.swift`
- `UITableView` with `UITableView.automaticDimension`. I used it only for auto calculation UILabel.

### Resources used:
- AppIcon, arrows - I exported it from PaRiM.ipa 

### SPM packages used:
- DiffableDataSources: Apple style port of `UITableViewDiffableDataSource` for ios 9 or newer. For sync updated cells without any problem with "invalid section" and etc
- Realm: so, just database for store downloaded holidays cache. 