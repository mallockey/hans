import { execSync } from "child_process";
import { SoftwareReportItem, SoftwareToInstall } from "./types";

export const invokeCommand = (
  command: string,
  returnOutput?: boolean
): boolean | string => {
  try {
    const output = execSync(command, { encoding: "utf8" });
    if (returnOutput) return output;
  } catch (error) {
    return false;
  }
  return true;
};

export const checkIfInstalled = (
  software: SoftwareToInstall,
  softwareInstalledList: SoftwareReportItem[],
  softwareBrewReport: string
) => {
  const foundSoftwareInReport = softwareInstalledList.find(
    (softwareReport: SoftwareReportItem) =>
      software.reportDisplayName === softwareReport._name
  );

  if (foundSoftwareInReport) return true;

  let softwareAlreadyInstalledBrew = softwareBrewReport.split(/(\s)/);

  softwareAlreadyInstalledBrew = softwareAlreadyInstalledBrew.map((software) =>
    software.replace(/\n/g, "")
  );

  if (softwareAlreadyInstalledBrew.includes(software.brewName)) return true;

  return false;
};
