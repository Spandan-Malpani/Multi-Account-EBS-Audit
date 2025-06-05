import csv
import io

def find_unused_volumes(session, region):
    ec2 = session.client("ec2", region_name=region)
    unused_volumes = []
    paginator = ec2.get_paginator('describe_volumes')

    for page in paginator.paginate():
        for vol in page['Volumes']:
            if not vol.get("Attachments"):
                unused_volumes.append(vol)

    return unused_volumes

def format_as_html_table(results):
    html = "<h2 style='font-family: Arial, sans-serif;'>Unused EBS Volumes Report</h2>"

    has_data = any(item['Volumes'] for item in results)
    if not has_data:
        html += "<p style='font-family: Arial, sans-serif; font-size: 14px;'><strong>No unattached EBS volumes found in any account/region.</strong></p>"
        return html

    html += """
    <table style="border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; font-size: 14px;">
      <thead>
        <tr style="background-color: #f2f2f2;">
          <th style="border: 1px solid #ddd; padding: 8px;">Account ID</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Region</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Volume ID</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Size (GiB)</th>
          <th style="border: 1px solid #ddd; padding: 8px;">AZ</th>
          <th style="border: 1px solid #ddd; padding: 8px;">State</th>
        </tr>
      </thead>
      <tbody>
    """

    for item in results:
        for vol in item.get("Volumes", []):
            html += f"""
            <tr>
              <td style="border: 1px solid #ddd; padding: 8px;">{item['AccountId']}</td>
              <td style="border: 1px solid #ddd; padding: 8px;">{item['Region']}</td>
              <td style="border: 1px solid #ddd; padding: 8px;">{vol['VolumeId']}</td>
              <td style="border: 1px solid #ddd; padding: 8px;">{vol['Size']}</td>
              <td style="border: 1px solid #ddd; padding: 8px;">{vol['AvailabilityZone']}</td>
              <td style="border: 1px solid #ddd; padding: 8px;">{vol['State']}</td>
            </tr>
            """

    html += "</tbody></table>"
    return html

def format_as_csv(results):
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["Account ID", "Region", "Volume ID", "Size (GiB)", "Availability Zone", "State"])

    for item in results:
        for vol in item.get("Volumes", []):
            writer.writerow([
                item['AccountId'],
                item['Region'],
                vol['VolumeId'],
                vol['Size'],
                vol['AvailabilityZone'],
                vol['State']
            ])
    return output.getvalue()
