# UIView+TWLinear

UIView+TWLinear provide easy way to display subView linearly by extending UIView

## Usage

```objective-c
#import "UIView+TWLinear.h"

UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 50, 50)];

[view addSubviewLinear:label1];
[view addSubviewLinear:label2];
```
